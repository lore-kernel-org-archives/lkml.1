Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYHVSMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYHVSMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYHVSME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:12:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50647 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYHVSMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:12:03 -0400
Message-ID: <48AF014D.8040103@zytor.com>
Date: Fri, 22 Aug 2008 11:11:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080820162925.75a5e064@doriath.conectiva>	<48ADDF4F.2020401@zytor.com>	<48AE5FCF.6030103@zytor.com>	<20080822065012.GV14110@elte.hu>	<20080822113941.147a1db0@doriath.conectiva>	<20080822153451.GA8390@Krystal>	<20080822132948.57e47076@doriath.conectiva>	<20080822163520.GA9860@Krystal> <20080822142054.403cbdef@doriath.conectiva>
In-Reply-To: <20080822142054.403cbdef@doriath.conectiva>
Content-Type: multipart/mixed;
 boundary="------------030908030101030601060804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030908030101030601060804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Luiz, two more tests:

1. a small program to run in userspace and tell us what you get;
2. a patch against -linus for testing.

	-hpa


--------------030908030101030601060804
Content-Type: text/x-csrc;
 name="nopl.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nopl.c"

#include <stdio.h>

int main(void)
{
  unsigned int eax, edx;

  asm(".byte 0x0f,0x1f,0x84,0x00,0x98,0x98,0x98,0x98,0x92,0x90,0x90,0x90"
      : "=a" (eax), "=d" (edx)
      : "a" (0x88776655), "d" (0x44332211));

  printf("%08x:%08x\n", edx, eax);
  return 0;
}

--------------030908030101030601060804
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
 

--------------030908030101030601060804--
