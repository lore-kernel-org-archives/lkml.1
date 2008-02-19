Return-Path: <linux-kernel-owner+w=401wt.eu-S1761768AbYBSKZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761768AbYBSKZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYBSKZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:25:25 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:41743 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbYBSKZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:25:24 -0500
X-IronPort-AV: E=Sophos;i="4.25,375,1199682000"; 
   d="scan'208";a="48712892"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [BUG][RFC][GENERIC IRQ] linux-2.6.24 (delayed) disable IRQ feature not functional for handle_simple_irq
Date: Tue, 19 Feb 2008 10:25:13 -0000
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC125CCE48@limkexm2.ad.analog.com>
In-Reply-To: <alpine.LFD.1.00.0802182146020.7583@apollo.tec.linutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG][RFC][GENERIC IRQ] linux-2.6.24 (delayed) disable IRQ feature not functional for handle_simple_irq
Thread-Index: Achyb3TQz2NvObX/T5SJEJDgOk1szgAZQDhg
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Thomas Gleixner" <tglx@linutronix.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Feb 2008 10:25:22.0936 (UTC) FILETIME=[BC1E2780:01C872E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

I have reasonable doubt that the delayed disable feature on linux-2.6.24 for handle_simple_irq is broken.

In 2.6.22 there was something like this:

	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
		if (desc->chip->mask)
			desc->chip->mask(irq);
...

However in 2.6.24 the "DISABLED" IRQ in case it happens is never going to be masked.  

	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
		goto out_unlock;


I see a disabled IRQ being invoked in an endless loop.

-Michael

------------------------------------------------------------------
********* Analog Devices GmbH         michael.hennerich@analog.com
**  *****                                      Systems Engineering
**     ** Wilhelm-Wagenfeld-Strasse 6       
**  ***** D-80807 Munich                      
********* Germany                          
Registergericht München HRB 40368,  Geschäftsführer:  Thomas Wessel,  Vincent Roche,  Joseph E. McDonough 
