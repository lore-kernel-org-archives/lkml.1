Return-Path: <linux-kernel-owner+w=401wt.eu-S1762367AbZD1Rgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762367AbZD1Rgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZD1Rg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:36:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZD1Rg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:36:27 -0400
Date: Tue, 28 Apr 2009 13:36:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Tejun Heo <tj@kernel.org>, Dave Airlie <airlied@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
In-Reply-To: <20090428172226.GA15115@elte.hu>
Message-ID: <alpine.DEB.2.00.0904281331040.8066@gandalf.stny.rr.com>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com> <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
 <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain> <20090428172226.GA15115@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Apr 2009, Ingo Molnar wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > So yes, it would be good to automate it:
> > 
> > > If a tool was available to detect the hardware and create a 
> > > config tailored for the box, this use for a default config would 
> > > go away
> > 
> > Yeah, I've wished for that.
> 
> Steve (Cc:-ed) submitted such a script last year IIRC. It wasnt 
> particularly complex.

I've submitted the script  a few times to LKML but it is not exactly what 
people want, but is quite useful in the mean time.

What people want is a script that will analyze their system devices and 
enable all the configs that will support them.

My script requires that you have booted the kernel (or similar kernel with 
the same config options and modules). It then runs lsmod, and searches for 
the options that enable those modules. It then reads the current .config 
file and prints out a new config that disables all module configs that are 
not used to enable the modules found with lsmod.

Here's the code (perl script):

http://rostedt.homelinux.com/code/streamline_config.pl

The instructions on how to use it are at the top of the file.

This script has brought down my full kernel compile times with distcc from 
50 minutes to under 10.

-- Steve

