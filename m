Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbZLPSpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbZLPSpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932220AbZLPSpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:45:04 -0500
Received: from nox.protox.org ([88.191.38.29]:58077 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758784AbZLPSpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:45:01 -0500
Date: Wed, 16 Dec 2009 19:41:48 +0100
From: Jerome Glisse <glisse@freedesktop.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, dri-devel@lists.sourceforge.net
Subject: Re: radeon KMS causes GART Table Walk Errors (was: K8 ECC error with
 linux-2.6.32)
Message-ID: <20091216184148.GB22703@localhost.localdomain>
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
 <200912152300.46325.johannes.hirte@fem.tu-ilmenau.de>
 <20091216071443.GA18814@aftab>
 <200912161558.30819.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912161558.30819.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 03:58:30PM +0100, Johannes Hirte wrote:
> Am Mittwoch 16 Dezember 2009 08:14:43 schrieb Borislav Petkov:
> > On Tue, Dec 15, 2009 at 11:00:46PM +0100, Johannes Hirte wrote:
> > > This patch (as the BIOS option) will only disable the error reports. The
> > > error itself will still occur, right? So necessary to find out why the
> > > radeon driver trigger this error.
> > 
> > Because the graphics driver does aperture accesses with no
> > matching GART translation, and the hw generates mchecks for
> > that. The whole story on GART table walk errors is in section
> > "13.10.1 GART Table Walk Error Reporting" in the document here:
> > http://support.amd.com/us/Processor_TechDocs/32559.pdf
> > 
> > I can't say for sure about your BIOS, but if it is done as described in
> > the abovementioned section, the BIOS option should disable logging of
> > the error, which implies reporting too.
> > 
> > The patch is still needed for machines that do not have that BIOS
> > option.
> 
> Disabling in BIOS doesn't made any difference. The errors were still reported. 
> Your patch disabled it. But I think this will make work harder for driver 
> developers as they won't get this error anymore. Could this be made changeable 
> on runtime/boottime?
> 
> I've added drm people to CC as they're responsible for this error.
> 
> 
> regards,
>   Johannes

More context would be usefull. Are you using KMS ? If so is your userspace
KMS capable ? Does this GART error happen all the time or only after sometimes
or when doing somethings specific ?

Cheers,
Jerome
