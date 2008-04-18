Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbYDRMl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbYDRMl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYDRMlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:41:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3096 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752785AbYDRMlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:41:21 -0400
Date: Fri, 18 Apr 2008 14:41:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] ThinkPad ACPI: fix possible NULL pointer dereference
Message-ID: <20080418124111.GB4966@ucw.cz>
References: <20080416174421.442716301@gmail.com>> <48063bc9.2533440a.1932.1fc1@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48063bc9.2533440a.1932.1fc1@mx.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Fix potential NULL pointer dereference if kstrdup failed
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> ---
> 
> Index: linux-2.6.git/drivers/misc/thinkpad_acpi.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/misc/thinkpad_acpi.c	2008-04-16 20:35:34.000000000 +0400
> +++ linux-2.6.git/drivers/misc/thinkpad_acpi.c	2008-04-16 20:36:38.000000000 +0400
> @@ -5826,7 +5826,7 @@ static void __init get_thinkpad_model_da
>  
>  	tp->model_str = kstrdup(dmi_get_system_info(DMI_PRODUCT_VERSION),
>  					GFP_KERNEL);
> -	if (strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
> +	if (tp->model_str && strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
>  		kfree(tp->model_str);
>  		tp->model_str = NULL;
>  	}

are you sure? This seems to assume machine is thinkpad if kstrdup
fails... which is very wrong.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
