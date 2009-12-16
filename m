Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbZLPO6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbZLPO6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbZLPO6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:58:36 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:52432 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbZLPO6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:58:35 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Borislav Petkov <borislav.petkov@amd.com>
Subject: radeon KMS causes GART Table Walk Errors (was: K8 ECC error with linux-2.6.32)
Date: Wed, 16 Dec 2009 15:58:30 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-fglrx; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de> <200912152300.46325.johannes.hirte@fem.tu-ilmenau.de> <20091216071443.GA18814@aftab>
In-Reply-To: <20091216071443.GA18814@aftab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912161558.30819.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 16 Dezember 2009 08:14:43 schrieb Borislav Petkov:
> On Tue, Dec 15, 2009 at 11:00:46PM +0100, Johannes Hirte wrote:
> > This patch (as the BIOS option) will only disable the error reports. The
> > error itself will still occur, right? So necessary to find out why the
> > radeon driver trigger this error.
> 
> Because the graphics driver does aperture accesses with no
> matching GART translation, and the hw generates mchecks for
> that. The whole story on GART table walk errors is in section
> "13.10.1 GART Table Walk Error Reporting" in the document here:
> http://support.amd.com/us/Processor_TechDocs/32559.pdf
> 
> I can't say for sure about your BIOS, but if it is done as described in
> the abovementioned section, the BIOS option should disable logging of
> the error, which implies reporting too.
> 
> The patch is still needed for machines that do not have that BIOS
> option.

Disabling in BIOS doesn't made any difference. The errors were still reported. 
Your patch disabled it. But I think this will make work harder for driver 
developers as they won't get this error anymore. Could this be made changeable 
on runtime/boottime?

I've added drm people to CC as they're responsible for this error.


regards,
  Johannes
