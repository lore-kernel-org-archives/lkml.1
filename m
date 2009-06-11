Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbZFKUIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbZFKUIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZFKUIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:08:31 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37190 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZFKUIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:08:30 -0400
Date: Thu, 11 Jun 2009 22:10:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Magnus Damm <damm@igel.co.jp>, Paul Mundt <lethal@linux-sh.org>
Cc: git-commits-head@vger.kernel.org
Subject: Re: sh: include empty_zero_page in text
Message-ID: <20090611201048.GA8817@uranus.ravnborg.org>
References: <200906111903.n5BJ32vd019484@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906111903.n5BJ32vd019484@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 07:03:02PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/53c0054c3f11b49fc09f24e46f58661def952728
> Commit:     53c0054c3f11b49fc09f24e46f58661def952728
> Parent:     7bce6c2740fab36708233e998a9e53115649b193
> Author:     Magnus Damm <damm@igel.co.jp>
> AuthorDate: Mon May 11 08:45:27 2009 +0000
> Committer:  Paul Mundt <lethal@linux-sh.org>
> CommitDate: Mon May 11 18:42:14 2009 +0900
> 
>     sh: include empty_zero_page in text
>     
>     Include empty_zero_page in _text. This fixes a problem
>     introduced by c3e2586b794b12ffcdf69b4e547030b51e18e6d9
>     which results in broken boot on R2D-Plus.
>     
>     Signed-off-by: Magnus Damm <damm@igel.co.jp>
>     Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/sh/kernel/vmlinux.lds.S |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
> index d737230..f53c76a 100644
> --- a/arch/sh/kernel/vmlinux.lds.S
> +++ b/arch/sh/kernel/vmlinux.lds.S
> @@ -26,12 +26,13 @@ SECTIONS
>  	. = CONFIG_PAGE_OFFSET + CONFIG_MEMORY_START + CONFIG_ZERO_PAGE_OFFSET;
>  #endif
>  
> +	_text = .;		/* Text and read-only data */
> +
>  	.empty_zero_page : AT(ADDR(.empty_zero_page) - LOAD_OFFSET) {
>  		*(.empty_zero_page)
>  	} = 0
>  
>  	.text : AT(ADDR(.text) - LOAD_OFFSET) {
> -		_text = .;		/* Text and read-only data */
>  		HEAD_TEXT
>  		TEXT_TEXT

This change turned _text to be an absolute symbol.
Do you support rolocatable kernels then this may fail.

	Sam
