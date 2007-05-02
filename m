Return-Path: <linux-kernel-owner+w=401wt.eu-S2992731AbXEBE3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992731AbXEBE3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992730AbXEBE2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:28:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24858 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992715AbXEBE2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:28:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=xvdsSTVJbncL+D8f21BWDHAOOhGe1ZnJQRNsq14PdFZXSpyppSyIL6dLoV65gqZ09
	T3BPXFhObVmMcKrkJhwXQ==
Date: Tue, 1 May 2007 21:28:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Achim Leubner <achim_leubner@adaptec.com>, linux-kernel@vger.kernel.org
Subject: [patch 04/10] scsi: fix ambiguous gdthtable definition
In-Reply-To: <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Labeling a variable as __attribute_used__ is ambiguous: it means
__attribute__((unused)) for gcc <3.4 and __attribute__((used)) for
gcc >=3.4.  There is no such thing as labeling a variable as
__attribute__((used)).  We assume that we're simply suppressing a warning
here if gdthtable[] is declared but unreferenced.

Cc: Achim Leubner <achim_leubner@adaptec.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/scsi/gdth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -876,7 +876,7 @@ static int __init gdth_search_pci(gdth_pci_str *pcistr)
 /* Vortex only makes RAID controllers.
  * We do not really want to specify all 550 ids here, so wildcard match.
  */
-static struct pci_device_id gdthtable[] __attribute_used__ = {
+static struct pci_device_id gdthtable[] __attribute_unused__ = {
     {PCI_VENDOR_ID_VORTEX,PCI_ANY_ID,PCI_ANY_ID, PCI_ANY_ID},
     {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC,PCI_ANY_ID,PCI_ANY_ID}, 
     {PCI_VENDOR_ID_INTEL,PCI_DEVICE_ID_INTEL_SRC_XSCALE,PCI_ANY_ID,PCI_ANY_ID}, 
