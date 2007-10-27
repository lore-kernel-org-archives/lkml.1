Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbXJ0Snm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbXJ0Snm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXJ0Snf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:43:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:46912 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbXJ0Sne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=qps8N+AACVjQwkVY2qZGCXiaeMaEa195qJKg2ZysJ+Wn2o3Mx/kWp+MPeyCvBAAO5KkRx0TP3H1F/a5s71/zp50CeZYCNhs4IozGq+GSDMbt4nCP/lpRaXUoPDQnQ6EZSK3v5cH8r48vPIDMhSaWXz8dbZgQwuyoQeLGJlenRug=
Date: Sat, 27 Oct 2007 22:43:28 +0400
To: Mikael Pettersson <mikpe@it.uu.se>, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: [PATCH] Dump stack during sysctl registration failure
Message-ID: <20071027184328.GC9816@martell.zuzino.mipt.ru>
References: <200710271757.l9RHvcY9021751@harpo.it.uu.se> <20071027183453.GB9816@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027183453.GB9816@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 10:34:53PM +0400,  wrote:
> --- a/arch/powerpc/kernel/idle.c
> +++ b/arch/powerpc/kernel/idle.c
> @@ -122,7 +122,7 @@ static ctl_table powersave_nap_sysctl_root[] = {
>  	{
>  		.ctl_name	= CTL_KERN,
>  		.procname	= "kernel",
> -		.mode		= 0755,
> +		.mode		= 0555,

Speaking of...


[PATCH] Dump stack during sysctl registration failure

Let's make immediately obvious from where sysctl comes from and
messages itself more noticeable.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/sysctl_check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -1432,6 +1432,7 @@ static void set_fail(const char **fail, struct ctl_table *table, const char *str
 		printk(KERN_ERR "sysctl table check failed: ");
 		sysctl_print_path(table);
 		printk(" %s\n", *fail);
+		dump_stack();
 	}
 	*fail = str;
 }
