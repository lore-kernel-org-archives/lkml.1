Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZL0PaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZL0PaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 10:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZL0PaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 10:30:11 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44460 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbZL0PaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 10:30:10 -0500
Subject: Re: [PATCH] parisc: test off by one in sgl_frem() and dbl_frem()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B375F68.80301@gmail.com>
References: <4B375F68.80301@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Dec 2009 09:30:04 -0600
Message-Id: <1261927804.2697.4.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-27 at 14:21 +0100, Roel Kluin wrote:
> With `while (stepcount-- > 0)' stepcount reaches -1 after the loop.

This is true, but seems to be by design

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/parisc/math-emu/dfrem.c |    2 +-
>  arch/parisc/math-emu/sfrem.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Unless I am missing something?
> 
> diff --git a/arch/parisc/math-emu/dfrem.c b/arch/parisc/math-emu/dfrem.c
> index b983785..3283445 100644
> --- a/arch/parisc/math-emu/dfrem.c
> +++ b/arch/parisc/math-emu/dfrem.c
> @@ -234,7 +234,7 @@ dbl_frem (dbl_floating_point * srcptr1, dbl_floating_point * srcptr2,
>  		Dbl_subtract(opnd1p1,opnd1p2,opnd2p1,opnd2p2,opnd1p1,opnd1p2);
>  		roundup = TRUE;
>  	}
> -	if (stepcount > 0 || Dbl_iszero(opnd1p1,opnd1p2)) {
> +	if (stepcount >= 0 || Dbl_iszero(opnd1p1,opnd1p2)) {
>  		/* division is exact, remainder is zero */
>  		Dbl_setzero_exponentmantissa(resultp1,resultp2);
>  		Dbl_copytoptr(resultp1,resultp2,dstptr);
> diff --git a/arch/parisc/math-emu/sfrem.c b/arch/parisc/math-emu/sfrem.c
> index 3a1b7a3..ad87832 100644
> --- a/arch/parisc/math-emu/sfrem.c
> +++ b/arch/parisc/math-emu/sfrem.c
> @@ -229,7 +229,7 @@ sgl_frem (sgl_floating_point * srcptr1, sgl_floating_point * srcptr2,
>  		Sgl_subtract(opnd1,opnd2,opnd1);
>  		roundup = TRUE;
>  	}
> -	if (stepcount > 0 || Sgl_iszero(opnd1)) {
> +	if (stepcount >= 0 || Sgl_iszero(opnd1)) {
>  		/* division is exact, remainder is zero */
>  		Sgl_setzero_exponentmantissa(result);
>  		*dstptr = result;

Your patch does nothing to the actual execution flow (Sgl_iszero is true
if stepcount == 0) ... what's the point of applying it?

James


