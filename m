Return-Path: <linux-kernel-owner+w=401wt.eu-S1764291AbXGJSe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764291AbXGJSe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXGJSev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:34:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:44228 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbXGJSet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:34:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=CnlBIfu/JqCe+fg+6tVxRufnCDO835xgR5BwPgjXrn/XnpK5P/BkQjcKP4VnvGc2E
	ZM181ti0ecxfbUldNkbUg==
Message-ID: <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
Date: Tue, 10 Jul 2007 11:34:38 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-Reply-To: <20070710105240.GA20914@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070710105240.GA20914@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> >
> >  Container stuff.  Hold, I guess.  I was expecting updates from Paul.
>
> Paul,
>         Are you working on a new version? I thought it was mostly ready
> for mainline.
>

There are definitely some big changes that I want to make internally
to the framework, but I guess they don't have to block pushing the
basic framework to mainline.

I've got a new patchset that's primarily got all the various -mm fix
patches rolled into the appropriate original patches, along with plus
some small tweaks

- changed the Kconfig files to avoid using "select"
- adding the subsystem name as a prefix for each control file to
enforce namespace scoping
- misc contributions from others

Short-term I also want to:

- rethink the linked list that runs through each task to its css_group
object, since that seemed to hurt performance a bit, but for now that
can probably be solved by just ripping it out and going back to
scanning the tasklist to enumerate tasks in a container.

- extend the options parsing, so we can have more than just a list of
subsystems. Probably changing the existing -o<subsys1>,<subsys2>,...
to be one of:
  -osubsys=<subsys1>:<subsys2>:...,<otheropt>=<otherval>
  -osubsys=<subsys1>,subsys=<subsys2>,subsys=...,<otheropt>=<otherval>
  (what's the preferred convention for fs mount options with multiple values?)

I'd not realised that anything else depending on containers was ready
for upstream merge, but if CFS group support is ready then merging a
subset of them is probably a good idea, since this is an application
that I can see a lot of people wanting to play with.

Andrew, how about we merge enough of the container framework to
support CFS? Bits we could leave out for now include container_clone()
support and the nsproxy subsystem, fork/exit callback hooks, and
possibly leave cpusets alone for now (which would also mean we could
skip the automatic release-agent stuff). I'm in Tokyo for the Linux
Foundation Japan symposium right now, but I should be able to get the
new patchset to you for Friday afternoon.

Paul
