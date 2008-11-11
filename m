Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbYKKUyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbYKKUyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYKKUyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:54:22 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3593 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYKKUyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:54:21 -0500
Date: Tue, 11 Nov 2008 21:54:19 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.27] attempt to access beyond end of device
Message-ID: <20081111205419.GS10723@vanheusden.com>
References: <20081104172513.GH23232@vanheusden.com> <20081104172727.GJ23232@vanheusden.com> <20081111200247.GQ10723@vanheusden.com> <20081111203833.GR10723@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111203833.GR10723@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue Nov 11 11:09:27 CET 2008
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Odd, these modules were unloaded but if I unload them "by hand", the system
keeps running without any failures.
-ac
-battery
-button
-container
-dm_mirror
-dm_snapshot
-fan
-floppy
-ide_cd_mod
-parport_pc
-rng_core
-usbhid

The errors are, by the way:
[   90.355347] attempt to access beyond end of device
[   90.355413] dm-0: rw=0, want=4993757896, limit=565248
[   90.355490] Buffer I/O error on device dm-0, logical block 2496878947
[   90.355559] attempt to access beyond end of device
[   90.355614] dm-0: rw=0, want=1967413868, limit=565248
[   90.355674] Buffer I/O error on device dm-0, logical block 983706933
[   90.355748] attempt to access beyond end of device
[   90.355804] dm-0: rw=0, want=6151601454, limit=565248
[   90.355866] Buffer I/O error on device dm-0, logical block 3075800726
[   90.355921] attempt to access beyond end of device
[   90.355988] dm-0: rw=0, want=2896542408, limit=565248
[   90.356059] Buffer I/O error on device dm-0, logical block 1448271203
[  128.751683] attempt to access beyond end of device
[  128.751749] dm-0: rw=0, want=8168917190, limit=565248
[  128.751817] Buffer I/O error on device dm-0, logical block 4084458594
[  128.751887] attempt to access beyond end of device
[  128.751941] dm-0: rw=0, want=4756365548, limit=565248
[  128.752011] Buffer I/O error on device dm-0, logical block 2378182773
[  128.752075] attempt to access beyond end of device
[  128.752142] dm-0: rw=0, want=4510308232, limit=565248
[  128.752201] Buffer I/O error on device dm-0, logical block 2255154115
[  128.752256] attempt to access beyond end of device
[  128.752310] dm-0: rw=0, want=1847372720, limit=565248
[  128.752378] Buffer I/O error on device dm-0, logical block 923686359
[  128.820595] attempt to access beyond end of device
[  128.820665] dm-0: rw=0, want=5787791288, limit=565248
[  128.820733] Buffer I/O error on device dm-0, logical block 2893895643
[  128.820811] attempt to access beyond end of device
[  128.820872] dm-0: rw=0, want=6800015832, limit=565248
[  128.820929] Buffer I/O error on device dm-0, logical block 3400007915


On Tue, Nov 11, 2008 at 09:38:33PM +0100, Folkert van Heusden wrote:
> Hang on: it is not ide_pci_generic causing the filesystem errors. Still
> investigating.
> 
> On Tue, Nov 11, 2008 at 09:02:47PM +0100, Folkert van Heusden wrote:
> > While running my http://vanheusden.com/pyk/ script (which randomly
> > inserts and removes modules), the module 'ide_pci_generic' got unloaded
> > while filesystems were mounted that used that module. Of course the
> > system crashed but I think it should not be possible to unload
> > modules when resources it serves are still in use.
> > 
> > 
> > Folkert van Heusden
> > 
> > -- 
> > MultiTail cok yonlu kullanimli bir program, loglari okumak, verilen
> > kommandolari yerine getirebilen. Filter, renk verme, merge, 'diff-
> > view', vs.  http://www.vanheusden.com/multitail/
> > ----------------------------------------------------------------------
> > Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
> 
> 
> Folkert van Heusden
> 
> -- 
> MultiTail is een flexibele tool voor het volgen van logfiles en
> uitvoer van commando's. Filteren, van kleur voorzien, mergen,
> 'diff-view', etc. http://www.vanheusden.com/multitail/
> ----------------------------------------------------------------------
> Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com


Folkert van Heusden

-- 
MultiTail is een flexibele tool voor het volgen van logfiles en
uitvoer van commando's. Filteren, van kleur voorzien, mergen,
'diff-view', etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
