Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZHTRef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZHTRef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZHTRef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:34:35 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:48462 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbZHTRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:34:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lDn3CQf4lthxVs/mE6rAABA78/MikKkthy8RDe8/1ZbPTiJ5153BAsYZOCEWP8+5/R
         gVgUUaWFjc2PLyOzsDZEF3Z+VP7F/gMne20C795rIEICg+6Qi5gQKyFbQ6L1ymQHeY1v
         6jf01NAD6UI0bUjeI1z5mdPkj6vOmBDDDaR68=
Date: Thu, 20 Aug 2009 21:34:28 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: smp_scan_config - use signed long as scan area
	size
Message-ID: <20090820173427.GA8517@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsigned value potentially could be overlapped
if length parameter is that: length % 16 != 0.

This is not a problem at moment since all values
we pass now are 16 divisible (0x400 and 0x10000).

Though there is no need unsigned value anyway.
Max range pointed out by MP specification is
in kilobytes so plain "signed long" is enough.

This allow us to be on a safe side.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

(I doubt if we ever will need to scan 1G of physical
 memory with 16 byte step at booting procedure 'xcept
 memtest case)

Please review. Not sure if the patch is that worth
but anyway :)

 arch/x86/kernel/mpparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/mpparse.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6.git/arch/x86/kernel/mpparse.c
@@ -705,7 +705,7 @@ static void __init smp_reserve_bootmem(s
 #endif
 }
 
-static int __init smp_scan_config(unsigned long base, unsigned long length,
+static int __init smp_scan_config(unsigned long base, long length,
 				  unsigned reserve)
 {
 	unsigned int *bp = phys_to_virt(base);
