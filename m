Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbYHBPve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbYHBPve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYHBPvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:51:10 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:33289 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbYHBPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:51:08 -0400
Date: Sat, 2 Aug 2008 17:50:54 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
cc: Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: acer-wmi broken in latest git kernel on TravelMate 6492 (Insufficient
 arguments - method [WQAA])
Message-ID: <alpine.LNX.1.10.0808021640310.2294@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.2
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sat, 02 Aug 2008 15:51:06 +0000
	Bayes: 0.0001 Tokens: new, 198; hammy, 7; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.3 SARE_SUB_OBFU_Q0 FVGT - subject contains odd letter combination
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
X-Spam-Signature: eb566866938972d0bb4ac555b4596e1f94e5e146
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

running Linus' latest (2b12a4c) git kernel, acer-wmi triggers the 
following ACPI Error on my Acer TravelMate 6492:

acer-wmi: Acer Laptop ACPI-WMI Extras
ACPI Error (nseval-0159): Insufficient arguments - method [WQAA] needs 1, found 0 [20080609]
acer-wmi: Unable to detect available WMID devices

Reverting commit f3454ae8104efb2dbf0d08ec42c6f5d0fe9225bc (ACPICA: Add 
argument count checking to control method invocation via 
acpi_evaluate_object) makes acer_wmi work as before.

Doing a little debugging the call trace starting at acer_wmi_init() is:

WMID_set_capabilities() (called from drivers/misc/acer-wmi.c:1192)
wmi_query_block(WMID_GUID2, 1, &out) (called from drivers/misc/acer-wmi.c:747)
acpi_evaluate_object(handle, method, NULL, out) (called from drivers/acpi/wmi.c:350)
acpi_ns_evaluate(info) (called from drivers/acpi/namespace/nsxfeval.c:258)

Is it a bug in acer-wmi or in Acer's ACPI implementation? I can provide 
more information as necessary.

Sven
