Return-Path: <linux-kernel-owner+w=401wt.eu-S932340AbXE1VGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbXE1VGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbXE1VFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:05:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:64130 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbXE1VFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ITBHyAcr4WEDWNt0qhzDebw0LVYZRmPMPqHk/bYX7b0rbJDZv3u18+/QTA5cTIPkfbMe1FKmGAFx2VraFA7z9eSZy0D/iYq6+umDLugFl8OYw1nSlyEsJnw93PcOgBXgMVwzDp9D3vnzn1F7S1p8dGMSu5PiCvsbrFxp8HWiK+0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch] Add the device IDs for AMD/ATI SB700
Date: Mon, 28 May 2007 22:16:59 +0200
User-Agent: KMail/1.9.6
Cc: Henry Su <henry.su@amd.com>, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       xiaosuzi520@hotmail.com
References: <FFECF24D2A7F6D418B9511AF6F35860201B3658E@shacnexch2.atitech.com> <4656C8BC.6060807@garzik.org>
In-Reply-To: <4656C8BC.6060807@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705282216.59611.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Sorry for the late reply and thanks to Jeff for stepping in. :)

Since Jeff covered both status of your patches and administrative issues
I would only like to add one small hint for people adding support for
multi-function PCI chipsets (with multiple PCI device IDs):

It makes sense to put addition of _all_ new PCI IDs into the first patch
of the series and send it to PCI Maintainer (Hi Greg).  This should make
all other patches from the series independent of each other (in the usual
case I'm not talking about all crazy scenarios here).  After the patch
with PCI IDs gets applied upstream you may now send all other patches to
the respective maintainers without worrying about inter-patch dependencies
and without maintainers worrying about your patches not applying cleanly.

IIRC Intely guys are using this process when adding support for their new
chipsets and it works smoothly.

[ Yep, this process is the exception from the general "patch shouldn't add
  unused code" rule but the amount of _temporarily_ unused stuff is _minimal_
  and doing it this way saves a lot of time for all parties involved. ]

PS Greg/Jeff If I'm totally wrong on this please correct me...

Thanks,
Bart

On Friday 25 May 2007, Jeff Garzik wrote:
> Henry Su wrote:
> > I check the latest kernel source code with git, and find out that the
> > SMBus patch has not been applied yet,  
> 
> Correct.  When you don't see a patch in the upstream git tree 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git 
> then the next step is consult the MAINTAINERS file, and determine to 
> whom you should send a follow-up patch, or simply contact about the 
> status of a patch you just sent.  In this case, SMBus is in drivers/i2c 
> sub-directory, which leads us to find in MAINTAINERS,
> 
> I2C SUBSYSTEM
> P:      Jean Delvare
> M:      khali@linux-fr.org
> L:      i2c@lm-sensors.org
> T:      quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
> S:      Maintained
> 
> That tells us the maintainer of the subsystem, and also ("T:") an 
> external reference (a tree) to where the maintainer posts accepted 
> patches, prior to sending them upstream.
> 
> So for SMBus, you should make sure your SMBus changes appear in Jean 
> Delvare's quilt tree.  If they do not, create a new patch and send it to 
> Jean and CC i2c@lm-sensors.org and linux-kernel@vger.kernel.org.
> 
> 
> > and the patch for IDE  has not been  applied completely.one more device
> > id should be added to pata_atiixp.c, 
> > l list the patch as following, or you can fetch it from the attached file,
> > could you please apply this for me?  
> 
> Actually it has been applied -- the part that I maintain (drivers/ata/*) 
> is currently stored in a secondary tree, as described above.  Your patch 
> has been stored on the 'upstream' branch of 
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 
> Currently, the upstream Linux kernel is only accepting bug fixes.  I 
> merge ATA bug fixes (and sometimes simple PCI ID additions) into 
> libata-dev.git#upstream-fixes during this phase of development.  These 
> changes are sent upstream in 24-48 hours, to ensure that they will be 
> included in the next release (kernel 2.6.22).
> 
> All other ATA changes are merged into libata-dev.git#upstream.  When 
> Linus releases kernel 2.6.22, the "merge window" opens, allowing 
> non-bug-fix changes to be submitted upstream.  When the merge window 
> opens, I submit everything in libata-dev.git#upstream to Linus and 
> Andrew Morton for inclusion in the official upstream kernel tree.
> 
> That is our development process in a nutshell.
> 
> The kernel development process is conducted entirely via email, so you 
> see why it is so important to learn how to email patches in the proper 
> format.
> 
> 	Jeff
