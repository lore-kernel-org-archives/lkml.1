Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYGHVWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYGHVWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYGHVWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:22:41 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4187 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYGHVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:22:40 -0400
Subject: Re: [PATCH] padlock: don't whinge when loaded on a non-VIA cpu
From: Joe Perches <joe@perches.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, kmcmartin@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080708193741.GB28899@phobos.i.cabal.ca>
References: <20080708190427.GA28899@phobos.i.cabal.ca>
	 <20080708195211.1565f3d1@the-village.bc.nu>
	 <20080708193741.GB28899@phobos.i.cabal.ca>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 14:21:16 -0700
Message-Id: <1215552076.5553.205.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-08 at 15:37 -0400, Kyle McMartin wrote:
> diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
> index c666b4e..70ec14b 100644
> --- a/drivers/crypto/padlock-sha.c
> +++ b/drivers/crypto/padlock-sha.c
> @@ -253,6 +253,10 @@ static int __init padlock_init(void)
>  {
>  	int rc = -ENODEV;
>  
> +	if (!((boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR) &&
> +	     (boot_cpu_data.x86 >= 6)))	/* only on VIA C3 and above */
> +		return -ENODEV;
> +
>  	if (!cpu_has_phe) {
>  		printk(KERN_ERR PFX "VIA PadLock Hash Engine not detected.\n");
>  		return -ENODEV;

int rc doesn't need to be initialized to -ENODEV either.

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -251,7 +251,7 @@ static struct crypto_alg sha256_alg = {
 
 static int __init padlock_init(void)
 {
-	int rc = -ENODEV;
+	int rc;
 
 	if (!cpu_has_phe) {
 		printk(KERN_ERR PFX "VIA PadLock Hash Engine not detected.\n");


