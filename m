Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbXCVNQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbXCVNQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbXCVNQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:16:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57627 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXCVNQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:16:54 -0400
Subject: Re: [PATCH -mm] Fix lseek on /proc/kcore
From: Arjan van de Ven <arjan@infradead.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070322095600.GA6816@localhost.sw.ru>
References: <20070322095600.GA6816@localhost.sw.ru>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Mar 2007 14:14:35 +0100
Message-Id: <1174569275.1158.175.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 12:56 +0300, Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  fs/proc/inode.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -167,8 +167,9 @@ static loff_t proc_reg_llseek(struct fil
>  	llseek = pde->proc_fops->llseek;
>  	spin_unlock(&pde->pde_unload_lock);
>  
> -	if (llseek)
> -		rv = llseek(file, offset, whence);
> +	if (!llseek)
> +		llseek = default_llseek;
> +	rv = llseek(file, offset, whence);
>  

this has potential impact way outside kcore......

did you audit all proc users to see if they can deal with lseek?

