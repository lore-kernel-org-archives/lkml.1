Return-Path: <linux-kernel-owner+w=401wt.eu-S1765190AbXLMRsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765190AbXLMRsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760166AbXLMRsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:48:11 -0500
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:25386 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750929AbXLMRsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:48:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Nwqpri1f5RZHaSIG+YmColVRwGOHP/XODEavUs1YiKPOCfY9jx+Ko1mwx9aLbtvxUdM0a2q1xEZxCyxEMxm17AvD/Tl/E9GazMHmjo/gDP58AQnL5R3vFsM/tc6u1e8ASSJiDEYf3/ODvIlpaZeQNmHXETbu5ZWepnZuYwaH8No=  ;
X-YMail-OSG: e2YqCycVM1m9o_Na6C4LZ6tYL5Z7N5pvMGAFX2K.d.iuIS3tLtdGccg4jVTGiSl.QJFRGDDW2A--
Date: Thu, 13 Dec 2007 18:46:37 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: (was Re: 2.6.24-rc5-mm1) crypto/authenc.c select symbol in Kconfig
Message-ID: <20071213174636.GA30228@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 02:40:50AM -0800, Andrew Morton wrote:

i get here:

----
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  Building modules, stage 2.
  MODPOST 226 modules
ERROR: "crypto_hash_type" [crypto/authenc.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
---

which fails because crypto_hash_type is declared in crypto/hash.c. You might wanna
fix it like so:

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>


--- crypto/Kconfig.orig	2007-12-13 18:44:19.000000000 +0100
+++ crypto/Kconfig	2007-12-13 18:39:00.000000000 +0100
@@ -553,6 +553,7 @@ config CRYPTO_AUTHENC
 	tristate "Authenc support"
 	select CRYPTO_AEAD
 	select CRYPTO_MANAGER
+	select CRYPTO_HASH
 	help
 	  Authenc: Combined mode wrapper for IPsec.
 	  This is required for IPSec.

-- 
Regards/Gruﬂ,
    Boris.
