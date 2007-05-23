Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbXEWEyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbXEWEyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbXEWEyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:54:31 -0400
Received: from sccrmhc14.comcast.net ([204.127.200.84]:52662 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbXEWEya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:54:30 -0400
From: Dan Dennedy <dan@dennedy.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
Date: Tue, 22 May 2007 21:54:24 -0700
User-Agent: KMail/1.9.5
Cc: Arnd Bergmann <arnd@arndb.de>, Petr Vandrovec <petr@vandrovec.name>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070507021447.GA22197@vana.vc.cvut.cz> <200705201703.37561.arnd@arndb.de> <46506912.9020904@s5r6.in-berlin.de>
In-Reply-To: <46506912.9020904@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705222154.24787.dan@dennedy.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2007 08:28, Stefan Richter wrote:
> Arnd Bergmann wrote:
> > On Sunday 20 May 2007, Stefan Richter wrote:
> >>> Note that this data structure only needs conversion on x86_64 and ia64, 
but
> >>> not on powerpc and other 64 bit architectures that align __u64 also in
> >>> 32 bit mode.
> >> Is this conversion just unnecessary or actually harmful on ppc64 and 
others?
> > 
> > With the current patch, the compat_ioctl function does not handle the 
ppc32
> > version of the structure at all, so it's broken there, it would at least
> > need a 
> > 
> > 	case RAW1394_IOC_GET_CYCLE_TIMER:
> > 		err = raw1394_ioctl(NULL, file, cmd, arg);
> > 		break;
> 
> Dan,
> 
> maybe we should change
> 
> /* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
> struct raw1394_cycle_timer {
> 	/* contents of Isochronous Cycle Timer register,
> 	   as in OHCI 1.1 clause 5.13 (also with non-OHCI hosts) */
> 	__u32 cycle_timer;
> 
> 	/* local time in microseconds since Epoch,
> 	   simultaneously read with cycle timer */
> 	__u64 local_time;
> };
> 
> to
> 
> /* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
> struct raw1394_cycle_timer {
> 	/*
> 	 * least significant 32 bits are contents of Isochronous Cycle
> 	 * Timer register, as in OHCI 1.1 clause 5.13 (also with
> 	 * non-OHCI hosts)
> 	 */
> 	__u64 cycle_timer;
> 
> 	/*
> 	 * local time in microseconds since Epoch,
> 	 * simultaneously read with cycle timer
> 	 */
> 	__u64 local_time;
> };
> 
> before a libraw1394 with get-cycle-timer support is released.
> Shall I prepare according patches for raw1394 and libraw1394?

This seems like a good idea, and I have forwarded it to the ffado (formerly 
freebob) developers, specifically Pieter Palmers--the submitter of 
raw1394_read_cycle_timer--to get his feedback.
