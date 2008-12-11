Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbYLKVIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbYLKVIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbYLKVH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:07:58 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:52730 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbYLKVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:07:57 -0500
Date: Thu, 11 Dec 2008 22:09:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Message-ID: <20081211210917.GB27010@uranus.ravnborg.org>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net> <20081210191213.GA15273@uranus.ravnborg.org> <49414DBE.6070801@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49414DBE.6070801@vlnb.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> >>  drivers/scst/scst_lib.c      | 3689 
> >>  +++++++++++++++++++++++++++++++++++++
> >>  drivers/scst/scst_main.c     | 1919 +++++++++++++++++++
> >>  drivers/scst/scst_module.c   |   69
> >>  drivers/scst/scst_priv.h     |  513 +++++
> >>  drivers/scst/scst_targ.c     | 5458 
> >>  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  8 files changed, 12435 insertions(+)
> >
> >There was a lot af TRACE_ENTRY() / TRACE_EXIT() noise.
> >We should have proper tools for that by now (I hope).
> 
> Sorry, I don't see such tools with, for instance, a possibility to be 
> compiled out in non-debug builds.
> 
> From one side, I can agree, those TRACE_ENTRY()/TRACE_EXIT() statements 
> *may* look like a noise (I personally don't notice them), but, from 
> other side, in past times they have proved how usable they are. If an 
> SCST user has a problem, I simply ask him to make a debug build, then 
> enable entry_exit and some other logging levels, then reproduce the 
> problem and send me the logs. Then in most cases I can see what's wrong 
> and provide a fix without additional actions and questions.

I had ftrace in mind but it has not hit mainline yet.
But will do before this patchset does.

> 
> >We often ask for exported symbols to be documented - so one has
> >a slight idea of their purpose.
> 
> They are documented, near their prototypes in the public header files, 
> particularly, scst.h. It was done so, because it was supposed that one, 
> writing a target driver or dev handler will have on hands the header 
> files, not source code.
> 
> Should we move those comments from the functions prototypes to the 
> functions definitions?
If there will be multiple implmentations of the same prototype
we generally recommend to stick the comment in a .H file.
But otherwise keep it close to the source it describe with the
minimal hope that it gets updated.

Oh - and we do not distribute a stripped down headers only
version of the kernel. Users will see full kernel source.

	Sam
