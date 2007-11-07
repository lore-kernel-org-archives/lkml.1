Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbXKGWOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbXKGWOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbXKGWOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:14:02 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:54468 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757678AbXKGWOA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:14:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: BUG: usb Mouse continual disconnect (2.6.22.10) leading to eventual crash?
Date: Wed, 7 Nov 2007 17:13:36 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0B89769@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20071107123237.d318cdbf.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: usb Mouse continual disconnect (2.6.22.10) leading to eventual crash?
Thread-Index: AcghfWei/xNJuhdTTWyyTD9AXwo3CgADFewg
References: <F1D642E5A91BC94D9504EC83AE19E6B0B89760@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071107123237.d318cdbf.akpm@linux-foundation.org>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 07 Nov 2007 22:13:37.0285 (UTC) FILETIME=[71C33B50:01C8218B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : Andrew Morton [mailto:akpm@linux-foundation.org] 
> Envoyé : 7 novembre 2007 15:33
> 
> (+linux-usb-devel)
> 
> > On Wed, 7 Nov 2007 13:19:47 -0500 "Fortier,Vincent 
> [Montreal]" <Vincent.Fortier1@EC.GC.CA> wrote:
> > 
> > I'm having a preblem with a few workstations that are hard freezing 
> > from time to time since about a week.  Curiously since then we 
> > upgraded from
> > 2.6.20.6 to 2.6.20.10...
> > 

[.....]

> > 
> > Looking at the changes between 2.6.20.6 and 2.6.20.10 I only found 
> > this USB related:
> > 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=commit;h=0e22438a5adfdf32b3bb1c75c81c01a29fba9770
> > 
> > I'm presuming that maybie eventually it might hit a input max barrier 
> > (like a max of 1024) and then the kernel would be crashing?
> > 
> > Help very much appreciated!
> 
> People are going to want to know if this is still happening 
> in 2.6.23 or 2.6.24-rc2, please.

I andrew,

(logged-in at wrok to make proper reply)

It might be tricky to test properly on 2.6.23.1 since theses are all operationnal aviation forecaster workstations 24/7 .... And sadly the problem only occur on a few of theses workstations AFAIK randomly ???  Actually many of them did not had any problems using the exact same FAI reinstallation using the same hardware..?!?!.

If someone thinks that the problem might effectively be the usb patch that I mentionned before (or any other patch that might make suddently thoses stations to freeze dur to a change that occur between 2.6.20.6 and .10) I would then be able to push a new kernel on thoses workstations without the offending patch(es) and have a clear answer within a week.

I also need to mention that our 2.6.20.6 build contained CFS v20.5 and the new 2.6.20.10 build contains CFS v22 although I doubt it is the cause of the freezing problem but hey, never know.  Although I could probably rebuild and push a new 2.6.20.10 without CFS to be sure.

I'm also currently following the problem occurring on a station and I hope it will freeze at an evident input entry.  Here where it is now:
Nov  7 22:04:44 mammatus kernel: [100926.387652] usb 2-1: USB disconnect, address 118
Nov  7 22:04:44 mammatus kernel: [100926.627502] usb 2-1: new low speed USB device using uhci_hcd and address 119
Nov  7 22:04:45 mammatus kernel: [100926.804006] usb 2-1: configuration #1 chosen from 1 choice
Nov  7 22:04:45 mammatus kernel: [100926.820213] input: Logitech USB-PS/2 Optical Mouse as /class/input/input729
Nov  7 22:04:45 mammatus kernel: [100926.820304] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1
Nov  7 22:11:55 mammatus kernel: [101356.846746] usb 2-1: USB disconnect, address 119
Nov  7 22:11:56 mammatus kernel: [101357.590408] usb 2-1: new low speed USB device using uhci_hcd and address 120
Nov  7 22:11:56 mammatus kernel: [101357.766609] usb 2-1: configuration #1 chosen from 1 choice
Nov  7 22:11:56 mammatus kernel: [101357.782803] input: Logitech USB-PS/2 Optical Mouse as /class/input/input730
Nov  7 22:11:56 mammatus kernel: [101357.782897] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1

vin

