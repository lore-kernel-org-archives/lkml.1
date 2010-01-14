Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367Ab0ANUb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0ANUb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971Ab0ANUb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:31:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:34149 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab0ANUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:31:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=pE9KtaWGc1N9SLAsXBcUic+1Fom6bY6hyA6CtGwrhQvOUQGGUeXwNWajd/HPK7K5yP
         YsqAfHpanEzS0fgzhNg3QbblchuSUIU4vPYZB/4KqwgaUkw+ohjvja0lL7cFRUvVP2m+
         oKt6ifmE9uG9F+87JJ/x4UNW2BdLrTEOXQ9BA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SATA_SIL on IXP425 workaround
Date: Thu, 14 Jan 2010 21:29:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
References: <m33a4nfvva.fsf@intrepid.localdomain> <201001141659.19687.bzolnier@gmail.com> <20100114192210.62593ead@lxorguk.ukuu.org.uk>
In-Reply-To: <20100114192210.62593ead@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <201001142129.38781.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 January 2010 08:22:10 pm Alan Cox wrote:
> > FWIW your patch is now in my atang tree (I'm aware that Jeff is working
> > on generic solution but in the meantime this non-intrusive patch allows
> > sata_sil to work on IXP425).
> 
> I think this is the wrong place. If your platform can't do MMIO properly
> then the platform pci_iomap or pci quirk code should do the needed
> cleaning up, not put turds into the drivers. Why not just quirk it on your
> specific platform and clear the MMIO mapping.

I think that you misinterpreted the issue -- according to Krzysztof MMIO
works just fine, only 8/16-bit MMIO reads are a problem (please note that
using mixed PIO/MMIO access is still a win over pure PIO access and also
that sata_sil doesn't support pure non-MMIO operations currently)..

However if it gets fixed in the upstream kernel in some other way I'll
simply drop the patch during the next re-base of my tree (I just collect
ATA stuff that looks useful/interesting to me and which otherwise may
become lost)..

--
Bartlomiej Zolnierkiewicz
