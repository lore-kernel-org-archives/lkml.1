Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbYHHTgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbYHHTgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYHHTgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:36:44 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:28575 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYHHTgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:36:44 -0400
X-BigFish: VPS-7(z21eWzzzzzz32i6bh68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0K5ARSM-02-05R-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Regression in 2.6.27-rc2 in acpi_processor_init()
Date: Fri, 8 Aug 2008 14:36:33 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC59@sausexmb4.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression in 2.6.27-rc2 in acpi_processor_init()
Thread-Index: Acj5jhBiu+z6Tw1pTmuxXXaa+utFEA==
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Aug 2008 19:36:34.0118 (UTC) FILETIME=[10B74E60:01C8F98E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a regression when updated from 2.6.27-rc1 ro
2.6.27-rc2.  The noticeable symptom is the powernow-k8
driver stopped working because the call to 
acpi_processor_register_performance() is returning
-EINVAL.

Digging into the code a bit more, that's occurring
because acpi_processor_ppc_status is not set.
That should be set in acpi_processor_init(), but
that function is failing to register the ACPI
processor driver.

I've dug through the code and can't see why 
that call would fail.  It doesn't look like there
were any changes between 2.6.27-rc1 and 2.6.27-rc2,
but I may have missed something.

Any advice or suggestions in debugging this 
appreciated.

-Mark Langsdorf
Operating System Research Center
AMD

