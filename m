Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYKOWAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYKOWAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 17:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYKOWAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 17:00:34 -0500
Received: from lucidpixels.com ([75.144.35.66]:51940 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYKOWAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 17:00:33 -0500
Date: Sat, 15 Nov 2008 17:00:32 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
In-Reply-To: <slrnghu29r.6oa.Mario.Holbe@darkside.dyn.samba-tng.org>
Message-ID: <alpine.DEB.1.10.0811151659300.27937@p34.internal.lan>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan> <slrnghu29r.6oa.Mario.Holbe@darkside.dyn.samba-tng.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Nov 2008, Mario 'BitKoenig' Holbe wrote:

> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> I have enabled debugging in the libata.h file and I find that ata15 is
>> constantly being accessed for some reason, why is this?
> ...
>> Host: scsi14 Channel: 00 Id: 00 Lun: 00
>>    Vendor: _NEC     Model: DVD_RW ND-3520A  Rev: 1.04
>>    Type:   CD-ROM                           ANSI  SCSI revision: 05
>
> Well, if ata15 really is the CD-ROM, hal is likely to poll it :/
>
>
> regards
>   Mario
> -- 
> Evidently men are more intelligent than women. Every woman on earth
> believes that men should be able to read minds. Every man knows this
> is impossible. Ergo, we are more intelligent.

Yes, for this -specific- issue, it was HAL polling the DVD drive multiple 
times a second, this fixed that:

# hal-disable-polling --device /dev/sr0 
Following symlink from /dev/sr0 to /dev/scd0.
Polling for drive /dev/sr0 have been disabled. The fdi file written was
   /etc/hal/fdi/information/media-check-disable-storage_model_DVD_RW_ND_3520A.fdi

#

Justin.
