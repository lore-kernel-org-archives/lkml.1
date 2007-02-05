Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbXBEULa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbXBEULa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933160AbXBEULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:11:30 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:13947 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933127AbXBEUL3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:11:29 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during
 irq migration.
Date: Mon, 5 Feb 2007 12:11:19 -0800
Message-ID: <5986589C150B2F49A46483AC44C7BCA4907415@ssvlexmb2.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during
 irq migration.
Thread-Index: AcdJYG78fxl79wWHTV+L/hFXdLtQfwAADJfA
From: "Lu, Yinghai" <yinghai.lu@amd.com>
To: ebiederm@xmission.com
cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Luigi Genoni" <luigi.genoni@pirelli.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Natalie Protasevich" <protasnb@gmail.com>
X-OriginalArrivalTime: 05 Feb 2007 20:11:20.0857 (UTC)
 FILETIME=[CD4FE890:01C74961]
X-WSS-ID: 69D950E21WC6092414-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com [mailto:ebiederm@xmission.com] 
>> How about let apic_hangle_pending_vector take the irq too?

>We can't compute the vector by reading the hardware registers after
>we have acknowledged the irq.

>I hope that was the answer you were looking for I'm not quite certain
>what you mean by take.

I mean 


+static void apic_handle_pending_vector(unsigned vector)
+{
+	unsigned irr;
+	int irq;
+
+	irq = __get_cpu_var(vector_irq)[vector];
+	if (irq >= 0)
+		return;
+
+	/* If the irq we are servicing has moved and is not pending
+	 * free it's vector.
+	 */

==>

+static void apic_handle_pending_vector(unsigned vector, unsigned irqx)
+{
+	unsigned irr;
+	int irq;
+
+	irq = __get_cpu_var(vector_irq)[vector];
+	if ( (-irq) != irqx)
+		return;
+ 
+
+	/* If the irq we are servicing has moved and is not pending
+	 * free it's vector.
+	 */



