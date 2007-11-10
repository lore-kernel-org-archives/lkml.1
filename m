Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbXKJSmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbXKJSmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 13:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXKJSmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 13:42:23 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:8436 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbXKJSmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 13:42:22 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2007 13:42:22 EST
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Sat, 10 Nov 2007 10:37:13 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH] Add quirk to set AHCI mode on ICH boards
Date: Sat, 10 Nov 2007 10:37:15 -0800
Message-ID: <DBFABB80F7FD3143A911F9E6CFD477B0329351A3@hqemmail02.nvidia.com>
In-Reply-To: <47351FE1.4000001@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Add quirk to set AHCI mode on ICH boards
thread-index: AcgjRq7KOjVy2eZrS36idf0gR4hlmwAgaRyw
References: <20071109020235.GA2031@ceren>	<20071109023129.GA25581@havoc.gtf.org>	<4733D421.7000505@rtr.ca>	<20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu> <47351FE1.4000001@garzik.org>
From: "Allen Martin" <AMartin@nvidia.com>
To: "Jeff Garzik" <jeff@garzik.org>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Mark Lord" <liml@rtr.ca>, "Riki Oktarianto" <rkoktarianto@gmail.com>,
       <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 10 Nov 2007 18:37:13.0340 (UTC) FILETIME=[B5F7B3C0:01C823C8]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Alan Cox wrote:
> > On Thu, 8 Nov 2007 22:46:22 -0500
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> On Thu, Nov 08, 2007 at 10:29:37PM -0500, Mark Lord wrote:
> >>> And I might even privately patch my own kernels to map 
> the ACHI BAR 
> >>> in the cases where the BIOS didn't...
> >> The inability to do this in the general case is the main 
> reason why 
> >> AHCI was not unconditionally enabled, even in IDE mode, 
> when it was 
> >> originally added...  :/
> > 
> > We've done it all the time for various devices without 
> problems (eg S3 
> > video cards). I'd like to see it go in - although perhaps 
> attached to 
> > a force_ahci boot param initially
> 
> By forcing AHCI, your PATA devices will be inaccessible, in a 
> common configuration.  It also means shuffling users from one 
> driver to another, which induces breakage.
> 
> I was speaking wishfully.  Real life intrudes, alas.
> 

At least for NVIDIA controllers, loading the AHCI driver when the BIOS
is set to IDE mode is not recommended by NVIDIA.  Any AHCI workarounds
in the BIOS are likely to be disabled when set to IDE mode.  In practice
we don't expect to see a lot of users running an AHCI controller in IDE
mode unless they have explicitly disabled AHCI from the BIOS or the
system builder has some specific reason for shipping IDE mode by default
(like support for some legacy DOS or Win9x tools)

-Allen
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
