Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZLRNrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZLRNrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZLRNrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:47:12 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:47344 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZLRNrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:47:09 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Jerome Glisse <glisse@freedesktop.org>
Subject: Re: radeon KMS causes GART Table Walk Errors (was: K8 ECC error with linux-2.6.32)
Date: Fri, 18 Dec 2009 14:47:00 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-fglrx; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de> <20091216184148.GB22703@localhost.localdomain> <200912162031.48983.johannes.hirte@fem.tu-ilmenau.de>
In-Reply-To: <200912162031.48983.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912181447.00498.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 16 Dezember 2009 20:31:48 schrieb Johannes Hirte:
> Am Mittwoch 16 Dezember 2009 19:41:48 schrieb Jerome Glisse:
> > On Wed, Dec 16, 2009 at 03:58:30PM +0100, Johannes Hirte wrote:
> > > Am Mittwoch 16 Dezember 2009 08:14:43 schrieb Borislav Petkov:
> > > > On Tue, Dec 15, 2009 at 11:00:46PM +0100, Johannes Hirte wrote:
> > > > > This patch (as the BIOS option) will only disable the error
> > > > > reports. The error itself will still occur, right? So necessary to
> > > > > find out why the radeon driver trigger this error.
> > > >
> > > > Because the graphics driver does aperture accesses with no
> > > > matching GART translation, and the hw generates mchecks for
> > > > that. The whole story on GART table walk errors is in section
> > > > "13.10.1 GART Table Walk Error Reporting" in the document here:
> > > > http://support.amd.com/us/Processor_TechDocs/32559.pdf
> > > >
> > > > I can't say for sure about your BIOS, but if it is done as described
> > > > in the abovementioned section, the BIOS option should disable logging
> > > > of the error, which implies reporting too.
> > > >
> > > > The patch is still needed for machines that do not have that BIOS
> > > > option.
> > >
> > > Disabling in BIOS doesn't made any difference. The errors were still
> > > reported. Your patch disabled it. But I think this will make work
> > > harder for driver developers as they won't get this error anymore.
> > > Could this be made changeable on runtime/boottime?
> > >
> > > I've added drm people to CC as they're responsible for this error.
> > >
> > >
> > > regards,
> > >   Johannes
> >
> > More context would be usefull. Are you using KMS ? If so is your
> > userspace KMS capable ? Does this GART error happen all the time or only
> > after sometimes or when doing somethings specific ?
> 
> Yes I'm using KMS when this error occours.
> Hardware:
> - Tyan Tiger K8W S8875 (AMD8151 Northbridge)
> - Radeon HD3650 AGP (RV635)
> 
> Software:
> - linux-2.6.32
> - libdrm-2.4.16
> - mesa-7.7_rc2
> - xf86-video-ati-9999 (latest git everytime)
> - KDE-4.3.4 with compositing enabled (OpenGL)
> 
> The errors occours after a while of normal desktop work. I haven't tested
> without KMS or compisiting. Will do this as well.

It's KMS related but not to compositing. Without KMS the errors don't occur. I 
found at least two log entries where the error occurred on initializing KMS. 
It happens reliable after a while working with X.

regards,
  Johannes
