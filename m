Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZJUVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZJUVVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbZJUVVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:21:39 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43526 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbZJUVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YeN/khm5XqAFHK6U+1f5Nhk0N3K8expoyHMmRY0cOMUmIVVtCtnbwaV/ImzhyY3UPJ
         iwBqQofCVhGGZFQFwGtpcYsqQlbOkUB5I3vJ3vch7cz99BdXgwbNNY4Qhjh7+0XohN94
         RfMYcO3kb8HPc0WIHpezuj2tWL2JW9TRG0Yrw=
Date: Wed, 21 Oct 2009 23:21:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>
Subject: Re: [PATCH] macintosh: Explicitly set llseek to no_llseek in
	ans-lcd
Message-ID: <20091021212137.GB4880@nowhere>
References: <20091010153314.827301943@linutronix.de> <20091010153349.966159859@linutronix.de> <alpine.LFD.2.00.0910212305090.3526@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910212305090.3526@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 11:07:18PM +0200, John Kacur wrote:
> From 0c2b412cdccf73bdeb19bb866bfe556942eaeca2 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Wed, 21 Oct 2009 23:01:12 +0200
> Subject: [PATCH] macintosh: Explicitly set llseek to no_llseek in ans-lcd
> 
> Now that we've removed the BKL here, let's explicitly set lleek to no_llseek
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  drivers/macintosh/ans-lcd.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/macintosh/ans-lcd.c b/drivers/macintosh/ans-lcd.c
> index 4ae8ec9..a1a1bde 100644
> --- a/drivers/macintosh/ans-lcd.c
> +++ b/drivers/macintosh/ans-lcd.c
> @@ -137,6 +137,7 @@ const struct file_operations anslcd_fops = {
>  	.write		= anslcd_write,
>  	.unlocked_ioctl	= anslcd_ioctl,
>  	.open		= anslcd_open,
> +	.llseedk	= no_llseek,


llseedk? :)


Should we better pushdown default_llseek to every to every
file operations that don't implement llseek?
I don't know how many of them don't implement llseek() though.

That said we can't continue anymore with this default attribution
of default_llseek() on new fops.

