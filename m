Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZLCMp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZLCMp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 07:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZLCMp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 07:45:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:23833 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZLCMp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 07:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=l8wowJArKEOdJGRJS9WpdVX1Klhz3ZMe7FsyLGMwATpRYQb59uHxJFcepxT9/DRgTp
         TOL1Urpsp2NpCwaBHBWvcoSno3l3r0nP/dW+NERoCuvyCwp9kxbcJo33V+lOupQCLuKM
         zy8XLd39zOyXjChlQI3jKAzuAOCcZq2VXwEdo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Thu, 3 Dec 2009 13:39:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <4B1771CD.3090409@garzik.org>
In-Reply-To: <4B1771CD.3090409@garzik.org>
MIME-Version: 1.0
Message-Id: <200912031339.14440.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 09:07:41 am Jeff Garzik wrote:
> On 11/25/2009 12:02 PM, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> >
> > I've been going through PATA drivers for the last few days to make
> > sure that we offer similar level of hardware support in the new PATA
> > drivers as with the old IDE subsystem and the following patchset is
> > the end result of said audit.
> >
> >
> > Inside:
> >
> > - many bugfixes
> >
> >    ( ata_piix, pata_artop, pata_atiixp, pata_efar, pata_cmd64x,
> >      pata_hpt3x3, pata_it8213, pata_legacy, pata_ns87415, pata_sis,
> >      pata_radisys, pata_rz1000&  pata_via )
> >
> > - add Power Management support for more controllers
> >
> >    ( pata_artop, pata_pdc2027x, pata_sl82c105 )
> >
> > - add 32-bit PIO support for more controllers
> >
> >    ( pata_artop, pata_atiixp, pata_efar, pata_cmd64x, pata_cs5520,
> >      pata_cs5530, pata_cs5535, pata_cypress, pata_hpt366, pata_hpt37x,
> >      pata_hpt3x2n, pata_it8213, pata_it821x, pata_jmicron, pata_ns87415,
> >      pata_opti, pata_pdc2027x, pata_pdc202xx_old, pata_rz1000,
> >      pata_sc1200, pata_scc, pata_sch, pata_serverworks, pata_sl82c105,
> >      pata_sis, pata_triflex&  pata_via )
> >
> > - fix QDI65x0 support in pata_legacy driver so pata_qdi driver can
> >    be finally removed
> >
> > - remove pata_qdi and pata_winbond drivers resulting in 600 LOC gone
> >
> >    (affected hardware is fully supported by pata_legacy driver now)
> >
> > - unify code for programming PIO and MWDMA timings for 'PIIX-like'
> >    controllers resulting in 200 LOC gone
> >
> >    ( ata_piix, pata_efar, pata_it8213, pata_oldpiix, pata_radisys&
> >      pata_rdc )
> >
> > - add ->init_host method for abstracting host specific controller
> >    initialization and then use it to cleanup Power Managment code
> >    resulting in over 100 LOC gone
> >
> >    ( pata_ali, pata_amd, pata_artop, pata_cmd640, pata_cmd64x,
> >      pata_cs5530, pata_hpt366, pata_hpt3x3, pata_it821x, pata_ninja32,
> >      pata_ns87415, pata_pdc2027x&  sata_sil )
> >
> > - misc fixes and cleanups
> 
> What are your plans for 2.6.33?

All past patches have been posted for review and have review issues addressed
already so right now I'm all busy with working on future patches.

> The merge window is upon us, which by strict rules means that anything 
> not already in libata-dev.git#upstream needs to wait until 2.6.34.
>
> However, bug fixes and the like should definitely be in 2.6.33. 
> ->init_host is definitely 2.6.34 material.  Some of the other stuff 
> could go either way.

If you would like to apply some of my patches to 2.6.33 you are more than
welcome to do it.  I can even prepare separate git tree with specific changes
to make it easier for you once you tell me which changes you would like to
see in it.

--
Bartlomiej Zolnierkiewicz
