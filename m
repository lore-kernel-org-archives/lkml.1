Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZKSOvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZKSOvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZKSOvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:51:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:16425 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZKSOvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:51:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=GJQtybJlXvlN90nEnNF620hGRsnvoZS1Ud/GYsh44kwfWspoao0zUUlwUgW6fhcNAZ
         VEwfqylL7b2NFrYptR1SOx33/jIIThMxP37J/O8iitOQcAP3ip3s2D5apLgsAUgPGsDc
         EvhBew//JkHGfZu1k+nLDnTgsMSWWY0fuT19E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 15:50:25 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911191517.15090.bzolnier@gmail.com> <20091119143351.1d0e2c59@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119143351.1d0e2c59@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191550.25476.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 15:33:51 Alan Cox wrote:
> On Thu, 19 Nov 2009 15:17:14 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > On Thursday 19 November 2009 14:16:36 Alan Cox wrote:
> > > > Only pata_hpt37x has broken cable detection while pata_hpt3x2n is
> > > > okay. ;)
> > > 
> > > I think you have that backwards according to the vendor drivers. 3x2n
> > > looks like it needs adjusting.
> > 
> > lol, just fix the damn pata_hpt37x driver _lacking_ ->cable_detect method..
> 
> It doesn't need one. It still sets the cable type in the pre reset
> function as the older drivers that haven't converted to a cable_detect
> method do.

If you know about other drivers still using ->pre_reset for cable detection
please let us know because they need fixing ASAP.

->cable_detect method is there for a reason, by knowingly not using it you
already have a buggy cable detection (since ->pre_reset ignores the mandatory
by spec part of cable detection which is probing slave before master) and
make it more likely to cause breakages in the future when some other developer
do a change under assumption that all host drivers use API correctly.

-- 
Bartlomiej Zolnierkiewicz
