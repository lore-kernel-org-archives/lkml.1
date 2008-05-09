Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYEIJMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYEIJMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYEIJL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:11:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:35359 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYEIJL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:11:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=vnMikU8iuGprDA97OmWF0ajGTzbuRQYASit3DRhANzALAWdaKKQgc9xIVPiBSyEhMTHCGRX1z12cK9/4xWwp5iFrSk0Za39e1boiz6sTUsGvIpSnQC8+eb0T/7c0MIbAcvWzJ8KSWEl5eGbuYP+27A8TXdOpHDjxu5VTwSZBzl0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: TAKADA Yoshihito <takada@mbf.nifty.com>
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
Date: Fri, 9 May 2008 11:27:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080508.165814.197343623.takada@mbf.nifty.com> <58cb370e0805080607n4f5de192o5a7371fd0fb1e9f8@mail.gmail.com> <20080509.112220.74748072.takada@mbf.nifty.com>
In-Reply-To: <20080509.112220.74748072.takada@mbf.nifty.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805091127.53737.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 May 2008, TAKADA Yoshihito wrote:
> Thanks for quick reply.
> 
> I tried 2.6.26rc1. It hangs same as 2.6.25.
> kernel 2.6.26rc1 with cs5520 cannot boot. cs5520 scans ide0 and ide1.
> It seems 2nd port DMA base issue was solved.

[...]

Thanks.

The following patch for 2.6.26-rc1 disables VDMA, please give it a try
(I haven't time to fully audit VDMA support yet but lets see if it is
the main source of the problems).

---
 drivers/ide/pci/cs5520.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -119,6 +119,7 @@ static const struct ide_dma_ops cs5520_d
 	.dma_timeout		= ide_dma_timeout,
 };
 
+/* FIXME: VDMA is disabled because it caused problems */
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
@@ -126,7 +127,6 @@ static const struct ide_dma_ops cs5520_d
 		.dma_ops	= &cs5520_dma_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
 				  IDE_HFLAG_CS5520 |		\
-				  IDE_HFLAG_VDMA |		\
 				  IDE_HFLAG_NO_ATAPI_DMA |	\
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE, \
 		.pio_mask	= ATA_PIO4,			\
