Return-Path: <linux-kernel-owner+w=401wt.eu-S964884AbXGTUku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884AbXGTUku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932714AbXGTUkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:40:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402AbXGTUkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:40:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=nl1oW/L0Hcj7YzzllzRbYQi27dtBgji7y2hx1HOzRCxjn42jrf0GDqlwlXt7bb2xz
	njpTfijgCr0L50djaTtvg==
Message-ID: <6599ad830707201339u413d860co739dc301fb6c9405@mail.gmail.com>
Date: Fri, 20 Jul 2007 13:39:58 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm PATCH 3/8] Memory controller accounting setup (v3)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric W Biederman" <ebiederm@xmission.com>
In-Reply-To: <6599ad830707201333s527f20eeuc39424c7b79626@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720082352.20752.37209.sendpatchset@balbir-laptop>
	 <20070720082429.20752.63919.sendpatchset@balbir-laptop>
	 <6599ad830707201333s527f20eeuc39424c7b79626@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Paul Menage <menage@google.com> wrote:
> On 7/20/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > +       mem = mem_container_from_cont(task_container(p,
> > +                                       mem_container_subsys_id));
> > +       css_get(&mem->css);
>
> The container framework won't try to free a subsystem's root container
> state, so this isn't needed.

Sorry, this was a reply to the wrong patch hunk.

The css_get() in mem_container_create() is the unnecessary one.

Also, rather than doing something like:

mem_container_from_cont(task_container(p, mem_container_subsys_id))

you'd be better off defining a similar wrapper to
mem_container_from_cont() called mem_container_from_task() that uses
task_subsys_state() rather than container_subsys_state() - you'll save
a few indirections.

Paul
