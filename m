Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYHGNlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYHGNlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYHGNlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:41:15 -0400
Received: from mxintlb03fl.versatel.de ([89.246.255.240]:51538 "EHLO
	mxintlb03fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYHGNlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:41:13 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 09:41:13 EDT
X-PMWin-Version: 2.6.1, Antispam-Engine: 2.6.0, Antivirus-Engine: 2.75.4
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.3959
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: AW: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Date: Thu, 7 Aug 2008 13:01:38 +0200
Message-ID: <85496C0905BB194FBDA1572571DBE95D0949FC36@FLBVEXCH01.versatel.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
thread-index: Acj3XB3Hc15asXEtRd2lWwcZC5m8WwBE9ytQ
From: "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>
To: <benh@kernel.crashing.org>, "Karsten Keil" <kkeil@suse.de>
Cc: "Sean MacLennan" <smaclennan@pikatech.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <isdn4linux@listserv.isdn4linux.de>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Aug 2008 11:01:40.0358 (UTC) FILETIME=[F82FE260:01C8F87C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please note that some cards require MEMIO. disabling it means disabling card types. if there are other future access modes and bridges, they can be implemented and then be selected by the vendor and device ids. read, write and fifo read, write are functions,  assigned to pointers at runtime. also wrapping (slightly) different hardware access is possible in the future. i think we should leave it like it is.

also note:  reading or writing fifos via PIO is optimized and almost as fast as MEMIO, since io-address byte never changes during fifo access. (auto-incemented after access).

-----Ursprüngliche Nachricht-----
Von: Benjamin Herrenschmidt [mailto:benh@kernel.crashing.org] 
Gesendet: Mittwoch, 6. August 2008 02:34
An: Karsten Keil
Cc: Sean MacLennan; Linus Torvalds; Andreas.Eversberg; isdn4linux@listserv.isdn4linux.de; linux-kernel@vger.kernel.org
Betreff: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti

On Wed, 2008-08-06 at 02:18 +0200, Karsten Keil wrote:
> 
> For the xhfc this may be a differnt choice, to select the access method on
> compile time, because the chip is mainly used for embedded systems, so it
> do not need to have a generic driver, the kerne is usually configured
> exactly for the hardware. On the other side, if you look into the xhfc
> chip and documentation, it is not so different from the HFC 4/8S, so maybe
> it would be possible to integrate it in hfcmulti as well.
> 
> And maybe here is a third way, to have a tristate CONFIG MEMIO,PIO,BOTH,
> which could be imlemented in the none indirect call version without
> overhead. I think I like this idea.

That's probably the best way. On powerpc, we have done a lot of work
to make it possible to have kernels support multiple platforms
even in the embedded space. You don't have to do it, but we found it
important to allow for it.

It forces to keep the code cleaner, but also makes it possible for
somebody release a range of products based on different designs to
support/release single binary images for the entire product range
(at least provided it's the same CPU core "family", we don't currently
support single binaries mixing for example 44x and 8xx processor
support). What to actually do at runtime being decided based on the
content of a "device-tree" passed to the kernel by the firmware or the
boot wrapper.

Thus, I find it a good idea to allow the option even for embedded
drivers to be built with runtime detection of access method.

Cheers,
Ben.


