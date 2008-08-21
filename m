Return-Path: <linux-kernel-owner+w=401wt.eu-S1760367AbYHUVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbYHUVe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbYHUVes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:34:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYHUVer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:34:47 -0400
Message-ID: <48ADDF4F.2020401@zytor.com>
Date: Thu, 21 Aug 2008 14:34:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080820162925.75a5e064@doriath.conectiva>
In-Reply-To: <20080820162925.75a5e064@doriath.conectiva>
Content-Type: multipart/mixed;
 boundary="------------030108020306090409090404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030108020306090409090404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

> 
>  Does this look like a kernel bug?
> 

No, it looks like a very common virtualizer bug.  Does the attached 
patch work for you?

	-hpa


--------------030108020306090409090404
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2763cb3..33193fe 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -157,8 +157,6 @@ static const struct nop {
 } noptypes[] = {
 	{ X86_FEATURE_K8, k8_nops },
 	{ X86_FEATURE_K7, k7_nops },
-	{ X86_FEATURE_P4, p6_nops },
-	{ X86_FEATURE_P3, p6_nops },
 	{ -1, NULL }
 };
 

--------------030108020306090409090404--
