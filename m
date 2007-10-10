Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbXJJTO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbXJJTO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXJJTOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:14:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58975 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXJJTOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:14:19 -0400
Date: Wed, 10 Oct 2007 21:14:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Ren=E9?= Rebe <rene@exactcode.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23
Message-ID: <20071010191413.GB3589@elte.hu>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org> <200710100944.16378.rene@exactcode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710100944.16378.rene@exactcode.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* René Rebe <rene@exactcode.de> wrote:

> Hi Linus et al.,
> 
> 2.6.23 does not build with my usual .config on x86_64 and gcc-4.2.1:

i know about 4 (low-impact, cornercase) build breakages for 2.6.23-final 
on x86:

- an uncommon embedded config combinatio: if CONFIG_EMBEDDED=y and
  CONFIG_BLOCK is unset. (a normally useless combination)

- an uncommon V4L config combination: mixed-modular-built-in driver V4L
  config variation. (CONFIG_VIDEO_SAA7146=y and CONFIG_VIDEO_BUF=m)

- an uncommon MTD config combination (normal systems do not need
  CONFIG_MTD configured)

- an uncommon CONFIG_USB_NET_CDC_SUBSET config combination (normal 
  systems should never hit that)

[ furthermore there are a few driver-firmware build options that break 
  and which are not correctly made dependent on !PREVENT_FIRMWARE_BUILD. 
  Again, this is not something one would normally configure. ]

your superblock build failure would be a new and so far unknown build 
breakage variant - please send the .config you used, and double-check 
that it's indeed a vanilla 2.6.23 tree.

	Ingo
