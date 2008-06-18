Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYFRVcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYFRVcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYFRVcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:32:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYFRVcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=uP4gLkLHqPYRKcRYD/411CH9BasG7+L7SE1ihayo9BfjGXZKhQLn7SGSDOldQlYvlh
         DSCbO72HXNt8u1hABkikueusmDDMIuZOZBs9XZUueHIzSajak5i1FkqZt6NTR11U86hp
         W49MTtEF1qQNAd57MgDdVucCYCjOPetg0c97s=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: update mptable fix with no ioapic
Date: Wed, 18 Jun 2008 14:32:56 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Daniel Exner <dex@dragonslave.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200805251600.26325.yhlu.kernel@gmail.com> <200806011317.38622.yhlu.kernel@gmail.com>
In-Reply-To: <200806011317.38622.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181432.57204.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


if the system doesn't have ioapic, we don't need to store entries for mptable
update

Reported-by: Daniel Exner <dex@dragonslave.de>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 04dbb35..e639d2f 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1173,6 +1173,9 @@ int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 	if (!enable_update_mptable)
 		return 0;
 
+	if (!acpi_ioapic)
+		return 0;
+
 	/* print the entry should happen on mptable identically */
 	intsrc.mpc_type = MP_INTSRC;
 	intsrc.mpc_irqtype = mp_INT;
