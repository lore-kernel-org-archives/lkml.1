Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYCCAIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYCCAIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYCCAIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:08:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45407 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbYCCAIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:08:41 -0500
Date: Sun, 2 Mar 2008 16:08:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH RFC] introduce pm_call() macro to get rid of most #ifdef
 CONFIG_PM
Message-ID: <20080302160820.1930a770@laptopd505.fenrus.org>
In-Reply-To: <20080302234308.GA10116@zarina>
References: <20080302234308.GA10116@zarina>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 02:43:08 +0300
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> Currently drivers handle CONFIG_PM this way:
> 
> #ifdef CONFIG_PM
> drv_suspend() {}
> drv_resume() {}
> #else
> #define drv_suspend NULL
> #define drv_resume NULL
> #endif
> 
> struct driver drv = {
> 	.suspend = drv_suspend,
> 	.resume = drv_resume,
> };
> 
> With this patch, the code above converts into:
> 
> drv_suspend() {}
> drv_resume() {}
> 
> struct driver drv = {
> 	.suspend = pm_call(drv_suspend),
> 	.resume = pm_call(drv_resume),
> };
> 
> GCC will optimize away suspend/resume calls if they're really
> not used.
> 


to be honest, at this point I would think it's time to remove CONFIG_PM, or rather,
just make it always be there and just get rid of the ifdefs. We're saving 2 words and a bit of code,
but only a case that not even the embedded guys use. 
