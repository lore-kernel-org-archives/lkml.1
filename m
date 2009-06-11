Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbZFKGgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbZFKGgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZFKGg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:36:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:45729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZFKGg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:36:27 -0400
Subject: RE: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
 trace support"
From: Peter Zijlstra <peterz@infradead.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EBBC6544B@irsmsx504.ger.corp.intel.com>
References: <tip-511b01bdf64ad8a38414096eab283c7784aebfc4@git.kernel.org>
	 <928CFBE8E7CB0040959E56B4EA41A77EBBC6544B@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 08:36:23 +0200
Message-Id: <1244702183.6691.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 07:30 +0100, Metzger, Markus T wrote:
> >-----Original Message-----
> >From: tip-bot for Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Thursday, June 11, 2009 1:37 AM
> >To: linux-tip-commits@vger.kernel.org
> >Cc: hpa@zytor.com; mingo@redhat.com; peterz@infradead.org; Metzger, Markus T; oleg@redhat.com;
> >tglx@linutronix.de; mingo@elte.hu
> >Subject: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
> >
> >Commit-ID:  511b01bdf64ad8a38414096eab283c7784aebfc4
> >Gitweb:     http://git.kernel.org/tip/511b01bdf64ad8a38414096eab283c7784aebfc4
> >Author:     Ingo Molnar <mingo@elte.hu>
> >AuthorDate: Thu, 11 Jun 2009 00:32:00 +0200
> >Committer:  Ingo Molnar <mingo@elte.hu>
> >CommitDate: Thu, 11 Jun 2009 00:32:00 +0200
> >
> >Revert "x86, bts: reenable ptrace branch trace support"
> >
> >This reverts commit 7e0bfad24d85de7cf2202a7b0ce51de11a077b21.
> >
> >A late objection to the ABI has arrived:
> >
> >   http://lkml.org/lkml/2009/6/10/253
> 
> I thought that this has been resolved. See for example http://lkml.org/lkml/2009/6/10/257.
> 
> Peters concerns were that Debug Store details are exposed to user space, which is
> not the case. Debug Store itself is fully in-kernel and the expectation of a 
> user-defined buffer can be implemented on top of the Debug Store changes that
> Peter expects are needed to support PEBS.
> 
> A user-defined trace buffer size is required to support different usage models.
> Some users only need a small amount of trace, whereas others need a big amount.
> The interface will have to reflect that in some way.

Right, your last email did explain how we could keep per task in-kernel
buffers and fill them from the DS and still have them of user-specified
size.

That would indeed keep the proposed ABI workable, what I'm still not
liking is that this buffer is in-kernel, but I guess that might be
something for other people to have an opinion on.

