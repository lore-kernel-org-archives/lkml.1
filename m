Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZFDAVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZFDAVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZFDAVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:21:01 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:55311 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZFDAVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:21:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RTqkcIqzeql0NQ78an6xoeIqvWtW2A2xU5SbldP6dx8ADxWzVgb7mMgRNtB5sRn/F/
         aGrIZtbb4dtXkr8tHwAM0Rmg53xiPdt0Yk2OsZejbQHXrxaLQCcaKJFxC+nb7JeNB+rc
         dHwLnUvjE2VncfLZT+5fcuuF/+MxSDQ8BwjUY=
Subject: Re: [PATCH v3] MFD: PCAP driver
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       linux-next <linux-next@vger.kernel.org>
In-Reply-To: <10f740e80906030738x3b42de18n189367b28a730c56@mail.gmail.com>
References: <1243399356.2263.46.camel@brutus>
	 <10f740e80906030738x3b42de18n189367b28a730c56@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Jun 2009 21:20:56 -0300
Message-Id: <1244074856.4767.26.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qua, 2009-06-03 às 16:38 +0200, Geert Uytterhoeven escreveu: 
> > +config EZX_PCAP
> > +       bool "PCAP Support"
> > +       depends on SPI_MASTER
> 
> It also has to depend on GENERIC_HARDIRQS, as it needs set_irq_type():

Hi Geert, sorry for this. :)



Fix EZX_PCAP dependency

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 060ee14..6557d60 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -243,7 +243,7 @@ config PCF50633_GPIO
 
 config EZX_PCAP
 	bool "PCAP Support"
-	depends on SPI_MASTER
+	depends on GENERIC_HARDIRQS && SPI_MASTER
 	help
 	  This enables the PCAP ASIC present on EZX Phones. This is
 	  needed for MMC, TouchScreen, Sound, USB, etc..

-- 
Daniel Ribeiro

