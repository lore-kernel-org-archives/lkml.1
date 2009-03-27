Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbZC0Kbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbZC0Kbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZC0KbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:31:23 -0400
Received: from smtp.movial.fi ([62.236.91.34]:50157 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZC0KbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:31:23 -0400
X-Greylist: delayed 1304 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2009 06:31:22 EDT
Message-ID: <49CCA5DF.6040804@movial.com>
Date: Fri, 27 Mar 2009 12:09:35 +0200
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: strange code in include/linux/kernel_stat.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Depending on whether the CONFIG_GENERIC_HARDIRQS option is enabled or not, the header file include/linux/kernel_stat.h defines the following two entities:

- the macro kstat_irqs_this_cpu for the case when CONFIG_GENERIC_HARDIRQS is set:

#define kstat_irqs_this_cpu(DESC) \
        ((DESC)->kstat_irqs[smp_processor_id()])

- another macro with the same name as the macro above but for the case CONFIG_GENERIC_HARDIRQS is not set:

#define kstat_irqs_this_cpu(irq) \
        (kstat_this_cpu.irqs[irq])

Apparently, it is assumed that the types for the macro argument are different, and depend on the value of CONFIG_GENERIC_HARDIRQS. Is this intentional?

Thanks,
Dmitri

