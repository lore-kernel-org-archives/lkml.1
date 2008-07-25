Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbYGYBSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbYGYBSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYGYBSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:18:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6102 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYGYBSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:18:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xz3GLXG8GrvsrT6+8sxmLImGDOy6LicO5xuZGvyTPbOvb+KEq7DD1slKgARR1eAyc
	LJSuIPnQrrwAbaeTP6Sew==
Message-ID: <6599ad830807241818k5cb288e2l3e62a01c2f102913@mail.gmail.com>
Date: Thu, 24 Jul 2008 21:18:21 -0400
From: "Paul Menage" <menage@google.com>
To: "Thomas Graf" <tgraf@suug.ch>
Subject: Re: [PATCH] Traffic control cgroups subsystem
Cc: "Ranjit Manomohan" <ranjitm@google.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, lizf@cn.fujitsu.com, kaber@trash.net
In-Reply-To: <20080724234553.GC20815@postel.suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0807221041210.1091@ranjit.corp.google.com>
	 <20080724234553.GC20815@postel.suug.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 7:45 PM, Thomas Graf <tgraf@suug.ch> wrote:
>
> It might have been easier to simply write a classifier which maps pids
> to classes. The interface could be as simple as two nested attributes,
> ADD_MAPS, REMOVE_MAPS which both take lists of pid->class mappings to
> either add or remove from the classifier.

You mean as processes fork/exit or move between cgroups you have to
update the pid->class mappings in the kernel's filter? That sounds way
too fragile to me.

>
> I have been working on this over the past 2 weeks, it includes the
> classifier as just stated, a cgroup module which sends notifications
> about events

What types of events? We discussed how to send cgroup notifications to
userspace in the containers mini-summit on Tuesday. Netlink was one of
the options discussed, but suffers from the problem that netlink
sockets are tied to a particular network namespaces. The solution that
seemed most favoured was to have pollable cgroup control files that
represent events (and optionally support event data via a fifo).

> as netlink messages and a daemon which creates qdiscs,
> classes and filters on the fly according to the configured distribution.

> It works both ingress (with some tricks) and egress.
>
> IMHO, there is no point in a cgroup interface if the user has to create
> qdiscs, classes and filters manually anyway.
>

The user can use whatever middleware they want (e.g. your daemon,
libcg, etc) to set up qdiscs and classes. I don't think that requiring
any particular userspace implementation is the right way to go. The
point of this patch was to provide a minimal way to tag
sockets/packets as belonging to a particular cgroup, in order to make
use of the existing traffic controll APIs.

Paul
