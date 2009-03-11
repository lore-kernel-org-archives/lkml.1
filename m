Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZCKNB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZCKNB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZCKNBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:01:17 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:29160 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZCKNBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=ixHFRHGCtD03gdjCgsHxRqHXNKsmh9yH3TE1KaKg/V+Fqw6UEl+gq577sh3x/J9NKv
         EAVxW54LZfRRf5Vnr91fmGTj0ozuAlCVT2FE8BrV9BNcfa9ukBo5LGm5k9uObv4WLlM3
         IqYdtZ4wUVnskDY1TDNieXLPfOqc5pkPOSFoY=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: drzeus-wbsd@drzeus.cx, Magnus Damm <magnus.damm@gmail.com>,
       ian@mnementh.co.uk, akpm@linux-foundation.org
Date: Wed, 11 Mar 2009 21:58:45 +0900
Message-Id: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
Subject: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmio_mmc: Minor fixes and cnf/irq changes

These patches fix two trivial issues and updates the tmio_mmc
driver to support hardware configurations that lack the cnf io
area (only a single ctl area) but may use multiple interrupts.

[PATCH 01/05] tmio_mmc: Fix one off, use resource_size() in probe()
[PATCH 02/05] tmio_mmc: Fix use after free in remove()
[PATCH 03/05] tmio_mmc: Break out cnf area operations
[PATCH 04/05] tmio_mmc: Make cnf area optional
[PATCH 05/05] tmio_mmc: Support multiple interrupts

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/mmc/host/tmio_mmc.c |  156 ++++++++++++++++++++++++++++++-------------
 drivers/mmc/host/tmio_mmc.h |    1 
 2 files changed, 109 insertions(+), 48 deletions(-)
