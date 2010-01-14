Return-Path: <linux-kernel-owner+w=401wt.eu-S932352Ab0ANWR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab0ANWR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932111Ab0ANWR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:17:27 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:62631 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0ANWR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:17:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=GSApMNhSpmoku0Dau2GHtoyphS+CrEGn6uhx3UFMrTgymFEYqLwLiSh86FMIjIzipw
         VNBjDiKEd6sEMRsO4vSQDImQY6JzC+GRKOeDA/KXANoSoOcuqwcQIXmQ61ZTn+6SNA5q
         K0KHPt4PrTA0MUYUhiETbusYtkrsY6DZTJh0g=
Message-ID: <4B4F98FB.4080709@gmail.com>
Date: Thu, 14 Jan 2010 23:21:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] IA64: Wrong attribute of HUB chip written in uv_setup() ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n_val should be assigned to n_val attribute of HUB chip.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this right? please review.

diff --git a/arch/ia64/uv/kernel/setup.c b/arch/ia64/uv/kernel/setup.c
index 7a5ae63..f149065 100644
--- a/arch/ia64/uv/kernel/setup.c
+++ b/arch/ia64/uv/kernel/setup.c
@@ -104,7 +104,7 @@ void __init uv_setup(char **cmdline_p)
 		uv_cpu_hub_info(cpu)->lowmem_remap_top =
 			lowmem_redir_base + lowmem_redir_size;
 		uv_cpu_hub_info(cpu)->m_val = m_val;
-		uv_cpu_hub_info(cpu)->n_val = m_val;
+		uv_cpu_hub_info(cpu)->n_val = n_val;
 		uv_cpu_hub_info(cpu)->pnode_mask = (1 << n_val) -1;
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
