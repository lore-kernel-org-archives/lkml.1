Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbZKYRZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbZKYRZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbZKYRZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:25:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63760 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113AbZKYRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:25:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=imCd5dnc136rTEtBhpkEeUfo+ZP0rbouZBex0Wcj/+1sCL1uOJhRkYX29LL2qmQtIa
         j0ylFxhJWh5rWswMz7QQyl8CH3+8m2cxIWLaYL945iFGDvtpO+ldRtpv5S26Rh8O8wVe
         PyVMVUS5ORhaiQ6Be5WV9J4w67Db+oOGk5w8w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Wed, 25 Nov 2009 18:24:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <4B0D6735.8000604@garzik.org>
In-Reply-To: <4B0D6735.8000604@garzik.org>
MIME-Version: 1.0
Message-Id: <200911251824.13702.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:19:49 pm Jeff Garzik wrote:
> On 11/25/2009 12:02 PM, Bartlomiej Zolnierkiewicz wrote:
> > I've been going through PATA drivers for the last few days to make
> > sure that we offer similar level of hardware support in the new PATA
> > drivers as with the old IDE subsystem and the following patchset is
> > the end result of said audit.
> 
> Thanks!
> 
> > - add 32-bit PIO support for more controllers
> >
> >    ( pata_artop, pata_atiixp, pata_efar, pata_cmd64x, pata_cs5520,
> >      pata_cs5530, pata_cs5535, pata_cypress, pata_hpt366, pata_hpt37x,
> >      pata_hpt3x2n, pata_it8213, pata_it821x, pata_jmicron, pata_ns87415,
> >      pata_opti, pata_pdc2027x, pata_pdc202xx_old, pata_rz1000,
> >      pata_sc1200, pata_scc, pata_sch, pata_serverworks, pata_sl82c105,
> >      pata_sis, pata_triflex&  pata_via )
> 
> This should be all in one patch.

For review & testing purposes it is better do it this way, I can merge
individual patches easily later if desirable.

> I'll let the comments from Alan and others trickle in before applying...

See comment above.

> > - add ->init_host method for abstracting host specific controller
> >   initialization and then use it to cleanup Power Managment code
> >   resulting in over 100 LOC gone
> >
> >   ( pata_ali, pata_amd, pata_artop, pata_cmd640, pata_cmd64x,
> >     pata_cs5530, pata_hpt366, pata_hpt3x3, pata_it821x, pata_ninja32,
> >     pata_ns87415, pata_pdc2027x & sata_sil )
> 
> hmmmm....  will reserve comment until I review it thoroughly, but I am a 
> bit reluctant to move away from the current struct-driver style driver 
> init/setup model.

This change is not moving away from it.  On the contrary -- it enhances
the current model by adding another possibility of doing things as the new
->init_host method is completely optional.

--
Bartlomiej Zolnierkiewicz
