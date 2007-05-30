Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbXE3MV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbXE3MV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXE3MVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:21:48 -0400
Received: from imf06aec.mail.bellsouth.net ([205.152.59.54]:34225 "EHLO
	imf06aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbXE3MVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:21:47 -0400
Date: Wed, 30 May 2007 06:47:11 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Problem with atl1 and msi in kernel 2.6.22-rc3
Message-ID: <20070530064711.570162f1@osprey.hogchain.net>
In-Reply-To: <200705300200.25412.jareguero@telefonica.net>
References: <200705300200.25412.jareguero@telefonica.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 02:00:25 +0200
Jose Alberto Reguero <jareguero@telefonica.net> wrote:

> I have problems with a M2V motherboard and atl1 driver with msi and
> kernel 2.6.22-rc3. With kernel 2.6.21 I had no problems.
> I must add in drivers/pci/quirks.c (line 1723):
> 
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, 
> quirk_disable_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, 0xe238,
> quirk_disable_msi);
> 
> to disable msi in the atl1.

See http://bugzilla.kernel.org/show_bug.cgi?id=8472.

A more general solution is to disable MSI for the VIA VT3351 (used by
the Asus M2V).  I attempted to do this in the -stable tree with
http://lkml.org/lkml/2007/5/26/167, but it was shot down because the
patch isn't upstream yet.

Unfortunately, I can't submit it upstream because the enabling
patch hasn't yet been applied upstream by the PCI maintainer. My
request for info on the status of the patch went unanswered.
http://lkml.org/lkml/2007/5/19/74

The enabling patch was submitted by Tejun Heo 9 May.
http://lkml.org/lkml/2007/5/9/213

It was applied to -stable (2.6.21.2) 23 May.
http://lkml.org/lkml/2007/5/23/385

It has not yet been applied upstream.  When it is, I'll push the atl1
MSI patch.

Jay

