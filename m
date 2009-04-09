Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbZDIK0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbZDIK0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932779AbZDIK0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:26:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35161 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761106AbZDIK0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:26:09 -0400
X-Sasl-enc: iDrmoefHxk1cga2xgmD5brbk6rWv3rOpyYN2bXZZXfUd 1239272767
Message-ID: <49DDCD3B.7000404@fastmail.fm>
Date: Thu, 09 Apr 2009 11:26:03 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 43/56] s390: Remove void casts
References: <> <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CCs]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  arch/s390/math-emu/math.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/arch/s390/math-emu/math.c b/arch/s390/math-emu/math.c
> index 3ee78cc..c1d43c9 100644
> --- a/arch/s390/math-emu/math.c
> +++ b/arch/s390/math-emu/math.c
> @@ -1917,7 +1917,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
>  
>                  emu_store_regd((opcode[1] >> 4) & 15);
>                  opc = *((__u32 *) opcode);
> -                dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>                  mathemu_copy_from_user(&temp, dxb, 8);
>                  /* call the emulation function */
>                  _fex = ((int (*)(struct pt_regs *, int, double *))
> @@ -1932,7 +1932,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
>  
>                  emu_store_rege((opcode[1] >> 4) & 15);
>                  opc = *((__u32 *) opcode);
> -                dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>                  mathemu_get_user(temp, dxb);
>                  /* call the emulation function */
>                  _fex = ((int (*)(struct pt_regs *, int, float *))
> @@ -1948,7 +1948,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
>                  emu_store_regd((opcode[1] >> 4) & 15);
>                  emu_store_regd((opcode[4] >> 4) & 15);
>                  opc = *((__u32 *) opcode);
> -                dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>                  mathemu_copy_from_user(&temp, dxb, 8);
>                  /* call the emulation function */
>                  _fex = ((int (*)(struct pt_regs *, int, double *, int))
> @@ -1964,7 +1964,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
>                  emu_store_rege((opcode[1] >> 4) & 15);
>                  emu_store_rege((opcode[4] >> 4) & 15);
>                  opc = *((__u32 *) opcode);
> -                dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>                  mathemu_get_user(temp, dxb);
>                  /* call the emulation function */
>                  _fex = ((int (*)(struct pt_regs *, int, float *, int))
> @@ -1982,7 +1982,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
>  			return SIGILL;
>                  emu_store_regd((opcode[1] >> 4) & 15);
>                  opc = *((__u32 *) opcode);
> -                dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>                  mathemu_copy_from_user(&temp, dxb, 8);
>                  /* call the emulation function */
>                  _fex = ((int (*)(struct pt_regs *, int, double *))
> @@ -1999,7 +1999,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
>                  __u32 opc;
>                  emu_store_rege((opcode[1] >> 4) & 15);
>                  opc = *((__u32 *) opcode);
> -                dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>                  mathemu_get_user(temp, dxb);
>                  /* call the emulation function */
>                  _fex = ((int (*)(struct pt_regs *, int, float *))
> @@ -2017,7 +2017,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
>  			return SIGILL;
>                  emu_store_rege((opcode[1] >> 4) & 15);
>                  opc = *((__u32 *) opcode);
> -                dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>                  mathemu_get_user(temp, dxb);
>                  /* call the emulation function */
>                  _fex = ((int (*)(struct pt_regs *, int, float *))
> @@ -2148,7 +2148,7 @@ int math_emu_ld(__u8 *opcode, struct pt_regs * regs) {
>          __u32 opc = *((__u32 *) opcode);
>          __u64 *dxb;
>  
> -        dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +        dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>          mathemu_copy_from_user(&fp_regs->fprs[(opc >> 20) & 0xf].d, dxb, 8);
>  	return 0;
>  }
> @@ -2161,7 +2161,7 @@ int math_emu_le(__u8 *opcode, struct pt_regs * regs) {
>          __u32 opc = *((__u32 *) opcode);
>          __u32 *mem, *dxb;
>  
> -        dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +        dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>          mem = (__u32 *) (&fp_regs->fprs[(opc >> 20) & 0xf].f);
>          mathemu_get_user(mem[0], dxb);
>  	return 0;
> @@ -2175,7 +2175,7 @@ int math_emu_std(__u8 *opcode, struct pt_regs * regs) {
>          __u32 opc = *((__u32 *) opcode);
>          __u64 *dxb;
>  
> -        dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +        dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>          mathemu_copy_to_user(dxb, &fp_regs->fprs[(opc >> 20) & 0xf].d, 8);
>  	return 0;
>  }
> @@ -2188,7 +2188,7 @@ int math_emu_ste(__u8 *opcode, struct pt_regs * regs) {
>          __u32 opc = *((__u32 *) opcode);
>          __u32 *mem, *dxb;
>  
> -        dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
> +        dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
>          mem = (__u32 *) (&fp_regs->fprs[(opc >> 20) & 0xf].f);
>          mathemu_put_user(mem[0], dxb);
>  	return 0;
> @@ -2201,7 +2201,7 @@ int math_emu_lfpc(__u8 *opcode, struct pt_regs *regs) {
>          __u32 opc = *((__u32 *) opcode);
>          __u32 *dxb, temp;
>  
> -        dxb= (__u32 *) calc_addr(regs, 0, opc>>12, opc);
> +        dxb= calc_addr(regs, 0, opc>>12, opc);
>          mathemu_get_user(temp, dxb);
>          if ((temp & ~FPC_VALID_MASK) != 0)
>  		return SIGILL;
> @@ -2216,7 +2216,7 @@ int math_emu_stfpc(__u8 *opcode, struct pt_regs *regs) {
>          __u32 opc = *((__u32 *) opcode);
>          __u32 *dxb;
>  
> -        dxb= (__u32 *) calc_addr(regs, 0, opc>>12, opc);
> +        dxb= calc_addr(regs, 0, opc>>12, opc);
>          mathemu_put_user(current->thread.fp_regs.fpc, dxb);
>          return 0;
>  }
>   

