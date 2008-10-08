Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYJHUXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYJHUXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYJHUW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:22:59 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50668 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbYJHUW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:22:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xtAo2OnAfqal+TDSEb4ki3sX6sZ2lf/E0O5d02U5eLEXA3yU+gMAjvAFrAvhJDuoxM
         i7PsPm2A4E1gx36R141dyiwhV61uztBMcL804OG8yjBxghfVoCU2kH7l9eubANr0xjs8
         5/4aYesgFqkTL6UXktATYXGn9eDkYs4L5ldOc=
Subject: Re: FRV/ARM unaligned access question
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <19824.1223464566@redhat.com>
References: <1223450773.8195.80.camel@brick>  <19824.1223464566@redhat.com>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 13:22:50 -0700
Message-Id: <1223497370.8195.97.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 12:16 +0100, David Howells wrote:
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> Switching to the packed struct algorithms also reduces the kernel size very
> slightly.  Before:
> 
> 	warthog>size vmlinux
> 	   text    data     bss     dec     hex filename
> 	2207836   66588  150189 2424613  24ff25 vmlinux
> 
> After:
> 
> 	warthog>size vmlinux
> 	   text    data     bss     dec     hex filename
> 	2207804   66588  150189 2424581  24ff05 vmlinux

Probably smaller as now the le values aren't being byteswapped anymore,
only the native endianess can use the struct version.  Care to look at
the kernel size with the following instead?

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] frv: switch unaligned access to the packed-struct implementation

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-frv/unaligned.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-frv/unaligned.h b/include/asm-frv/unaligned.h
index 839a2fb..6c61c05 100644
--- a/include/asm-frv/unaligned.h
+++ b/include/asm-frv/unaligned.h
@@ -13,7 +13,7 @@
 #define _ASM_UNALIGNED_H
 
 #include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/generic.h>
 
 #define get_unaligned	__get_unaligned_be
-- 
1.6.0.2.471.g47a76



