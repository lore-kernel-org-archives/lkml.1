Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYCaCCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYCaCCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYCaCCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:02:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54699 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752518AbYCaCCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:02:11 -0400
Date: Sun, 30 Mar 2008 21:02:07 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] x86_64: V2 Support for new UV apic
Message-ID: <20080331020207.GA20605@sgi.com>
References: <20080328191216.GA16455@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328191216.GA16455@sgi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix double-shift of apicid in previous patch.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
The code is clearly wrong.  I booted on an 8p AMD box and
had no problems. Apparently the kernel (at least basic booting) is
not too sensitive to incorrect apicids being returned. Most
critical-to-boot code must use apicids from the ACPI tables.


 arch/x86/kernel/genapic_64.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/genapic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/genapic_64.c	2008-03-30 20:37:18.000000000 -0500
+++ linux/arch/x86/kernel/genapic_64.c	2008-03-30 20:48:30.000000000 -0500
@@ -98,8 +98,6 @@ unsigned int read_apic_id(void)
 	id = apic_read(APIC_ID);
 	if (uv_system_type >= UV_X2APIC)
 		id  |= __get_cpu_var(x2apic_extra_bits);
-	else
-		id = (id >> 24) & 0xFFu;;
 	return id;
 }
 
