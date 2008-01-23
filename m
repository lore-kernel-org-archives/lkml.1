Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYAWXG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYAWXG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 18:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYAWXGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 18:06:19 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2629 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYAWXGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 18:06:18 -0500
Subject: Re: [PATCH][ppc] logical/bitand typo in powerpc/boot/4xx.c
From: Joe Perches <joe@perches.com>
To: Roel Kluin <12o3l@tiscali.nl>, Andy Whitcroft <apw@shadowen.org>
Cc: jwboyer@linux.vnet.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <4797C1AD.3040307@tiscali.nl>
References: <4797C1AD.3040307@tiscali.nl>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 15:05:27 -0800
Message-Id: <1201129527.4988.69.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-23 at 23:37 +0100, Roel Kluin wrote:
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/arch/powerpc/boot/4xx.c b/arch/powerpc/boot/4xx.c
> index ebf9e21..dcfb459 100644
> --- a/arch/powerpc/boot/4xx.c
> +++ b/arch/powerpc/boot/4xx.c
> @@ -104,7 +104,7 @@ void ibm4xx_denali_fixup_memsize(void)
>  	val = DDR_GET_VAL(val, DDR_CS_MAP, DDR_CS_MAP_SHIFT);
>  	cs = 0;
>  	while (val) {
> -		if (val && 0x1)
> +		if (val & 0x1)
>  			cs++;
>  		val = val >> 1;

I think this pattern should be added to checkpatch

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..147e573 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1337,6 +1337,11 @@ sub process {
 			}
 		}
 
+# Check for bitwise tests written as boolean
+		if ($line =~ /\&\&\s*0[xX]/) {
+			WARN("boolean test with hexadecimal, perhaps just 1 \&?\n" . $herecurr);
+		}
+
 # if and else should not have general statements after it
 		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
 		    $1 !~ /^\s*(?:\sif|{|\\|$)/) {


