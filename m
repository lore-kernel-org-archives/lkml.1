Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbZKGUg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbZKGUg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 15:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZKGUgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 15:36:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:48379 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751290AbZKGUgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 15:36:25 -0500
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 07 Nov 2009 21:36:27 +0100
From: "Marc Wetzel" <MarcWetzel@gmx.de>
Message-ID: <20091107203627.176580@gmx.net>
MIME-Version: 1.0
Subject: PROBLEM: Instant kernel reboot on Poulsbo+Atom PC if system has heavy
 USB-Load
To: linux-kernel@vger.kernel.org
X-Authenticated: #461418
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/F5SVD5pLFSTqXg/yWaqgQG9p4lu4bB4zsogBVPa
 3hc8YlCxOh0/XiGNxLP2C5ftJ9pmvIzBKB1A== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: cuLDA7IDQEV/IF08bnVpvwdCNzg2NQKh
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PROBLEM: Instant kernel reboot on Poulsbo+Atom PC if system has heavy USB load and/or USB Hangs

While investigating the problem, I found the following ERRATA on Intels web-site:

http://download.intel.com/design/chipsets/embedded/specupdt/319538.pdf

Extract:

19.          EHCI Controller Hang
Problem:     The EHCI host controller may hang if it is processing the schedule and system
             software accesses EHCI controller PCI configuration space registers 0xC0-0xCF,
             0xDC-0xDF, or 0xF0-0xF3
Implication: The BIOS may soft hang during boot; OR the system may hard-hang during OS
             operation; OR USB2.0 devices may fail to operate properly during OS operation.
Workaround: BIOS should remove all accesses to the listed PCI config registers while the schedule
             is running, except for 0xC0 (function disable) which can be done before EHCI init.
             Specialized software that accesses PCI configuration space should be avoided, or
             modified to avoid these registers.
Status:      For the steppings affected, see the Summary Tables of Changes.


>-/*

Is this errata relevant for my problems - In which source should I look to fix this?

BR
Marc



