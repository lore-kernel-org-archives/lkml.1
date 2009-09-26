Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZIZT1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZIZT1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZIZT1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:27:47 -0400
Received: from solo.fdn.fr ([80.67.169.19]:53823 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZIZT1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:27:47 -0400
Date: Sat, 26 Sep 2009 21:27:48 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH,TRIVIAL] Fix csum_ipv6_magic asm memory clobber
Message-ID: <20090926192748.GX7681@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like ip_fast_csum, the assembly snippet in csum_ipv6_magic needs a
memory clobber, as it is only passed the address of the buffer, not a
memory reference to the buffer itself.

Signed-Off-By: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: stable@kernel.org

diff --git a/arch/x86/include/asm/checksum_32.h b/arch/x86/include/asm/checksum_32.h
index 7c5ef8b..46fc474 100644
--- a/arch/x86/include/asm/checksum_32.h
+++ b/arch/x86/include/asm/checksum_32.h
@@ -161,7 +161,8 @@ static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	    "adcl $0, %0	;\n"
 	    : "=&r" (sum)
 	    : "r" (saddr), "r" (daddr),
-	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum));
+	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum)
+	    : "memory");
 
 	return csum_fold(sum);
 }
