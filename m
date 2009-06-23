Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbZFWQzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbZFWQzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758661AbZFWQzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:55:01 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:45971 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759719AbZFWQzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:55:00 -0400
X-Greylist: delayed 1862 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 12:54:56 EDT
Subject: genirq default_disable()
From: Pawel MOLL <pawel.moll@st.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Jun 2009 17:23:38 +0100
Message-Id: <1245774218.14443.120.camel@bri1004.bri.st.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

A quick question about the interrupt management... (the story takes
place in kernel/irq/chip.c ;-)

Here we have the default_enable():

static void default_enable(unsigned int irq)
{
        struct irq_desc *desc = irq_to_desc(irq);

        desc->chip->unmask(irq);
        desc->status &= ~IRQ_MASKED;
}

It calls chip->unmask(), which absolutely makes sense...

The default_disable(), however, is not symmetric:

static void default_disable(unsigned int irq)
{
}

Is there any reason why it shouldn't call chip->mask()?

I'll be more then happy to prepare a patch doing so, but maybe it's a
feature not a bug and I'm just missing something?

Best regards

Paweł

