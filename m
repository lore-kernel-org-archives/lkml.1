Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYJHNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYJHNjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 09:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYJHNjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 09:39:09 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41892 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753808AbYJHNjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 09:39:08 -0400
Date: Wed, 8 Oct 2008 15:39:06 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/17] checkpatch: include/asm checks should be anchored
In-Reply-To: <1218485592-6679-10-git-send-email-apw@shadowen.org>
Message-ID: <Pine.LNX.4.64.0810081537560.24611@vixen.sonytel.be>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
 <1218485592-6679-10-git-send-email-apw@shadowen.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-2033897805-1223473146=:24611"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-2033897805-1223473146=:24611
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 11 Aug 2008, Andy Whitcroft wrote:
> It is possible to have other include/asm paths within the tree which
> are not subject to the do not edit checks.  Ignore those.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
>  scripts/checkpatch.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 482768c..0e5af8e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1134,7 +1134,7 @@ sub process {
>  			$realfile = $1;
>  			$realfile =~ s@^[^/]*/@@;
>  
> -			if ($realfile =~ m@include/asm/@) {
> +			if ($realfile =~ m@^include/asm/@) {
>  				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
>  			}
>  			next;

I just stumbled on the same false positive, and found your patch.
Shouldn't the error message be updated, too?

--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1134,8 +1134,8 @@ sub process {
 			$realfile = $1;
 			$realfile =~ s@^[^/]*/@@;
 
-			if ($realfile =~ m@include/asm/@) {
-				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
+			if ($realfile =~ m@^include/asm/@) {
+				ERROR("do not modify files in include/asm, change architecture specific files in arch/<architecture>/include/asm or include/asm-<architecture>\n" . "$here$rawline\n");
 			}
 			next;
 		}


With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-2033897805-1223473146=:24611--
