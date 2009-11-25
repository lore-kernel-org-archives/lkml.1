Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbZKYRrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbZKYRrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbZKYRq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:46:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62771 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbZKYRq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:46:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=m7kLuL6OxhP1NXVowN78VBD5EYQtrEDwlhRbXCC5jJwq3Pu9kCBW/OokkOHYGYcHMq
         cTff7ldFB/66jiWFtsmDOZDru2+UV0YadfwQgzhgno5DOtAPs8RA8g4E0gy8+8JNFO3l
         OSlIkslDJqN8Y/USzpnMg5J3fk1jYY348oe7Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 17/86] pata_efar: fix register naming used in efar_set_piomode()
Date: Wed, 25 Nov 2009 18:32:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170422.5446.10637.sendpatchset@localhost> <20091125172541.1267490f@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125172541.1267490f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911251832.37101.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:25:41 pm Alan Cox wrote:
> > Rename 'idetm_port' and 'idetm_data' variables to 'master_port'
> > and 'master_data' respectively to match register naming used in
> > efar_set_dma_mode() and in ata_piix.c.
> 
> Probably better to do the reverse to match the docs ?

It just matches ata_piix.c code currently.

> > -	u16 idetm_data;
> > +	u8 master_port		= ap->port_no ? 0x42 : 0x40;
> > +	u16 master_data;
> 
> Please don't drop undocumented type changes in. And btw it uses unsigned

Oh, I forgot to document it in this patch.  Others should have it documented.

[ Will fix later. ]

> int here as all over the kernel because it produced better code in many
> cases

Better code is smaller code in this situation and this is clearly minor
issue anyway (since the code is not performance critical having cleaner
code wins over).

> These patches seem to spend a lot of time renaming everything in drivers

It just prepares the code for unification of code programming PIO and MWDMA
methods, see patch #18.

--
Bartlomiej Zolnierkiewicz
