Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYGJJYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYGJJYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYGJJYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:24:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYGJJYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:24:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=uPA//0HXSoOCM9bcr2M69mo5ibqKqyzbmCypwakNhyo0o5FDqhCUZ3SoSJOLdIvlQ
	w4x+3VzUySBvD7dyvdFvQ==
Message-ID: <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
Date: Thu, 10 Jul 2008 02:23:52 -0700
From: "Paul Menage" <menage@google.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Libcg Devel Mailing List" <libcg-devel@lists.sourceforge.net>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Peter Zijlstra" <pzijlstr@redhat.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Graf" <tgraf@redhat.com>, "Rik Van Riel" <riel@redhat.com>
In-Reply-To: <20080703155446.GB9275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701191126.GA17376@redhat.com>
	 <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080703155446.GB9275@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 8:54 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> As of today it should happen because newly execed process will run into
> same cgroup as parent.  But that's what probably we need to avoid.
> For example, if an admin has created three cgroups "database", "browser"
> "others" and a user launches "firefox" from shell (assuming shell is running
> originally in "others" cgroup), then any memory allocation for firefox should
> come from "browser" cgroup and not from "others".

I think that I'm a little skeptical that anyone would ever want to do that.

Wouldn't it be a simpler mechanism for the admin to simply have
wrappers around the "firefox" and "oracle" binaries that move the
process into the "browser" or "database" cgroup before running the
real binaries?

>
> I am assuming that this will be a requirement for enterprise class
> systems. Would be good to know the experiences of people who are already
> doing some kind of work load management.

I can help there. :-) At Google we have two approaches:

- grid jobs, which are moved into the appropriate cgroup (actually,
currently cpuset) by the grid daemon when it starts the job

- ssh logins, which are moved into the appropriate cpuset by a
forced-command script specified in the sshd config.

I don't see the rule-based approach being all that useful for our needs.

It's all very well coming up with theoretical cases that a fancy new
mechanism solves. But it carries more weight if someone can stand up
and say "Yes, I want to use this on my real cluster of machines". (Or
even "Yes, if this is implemented I *will* use it on my desktop" would
be a start)

Paul
