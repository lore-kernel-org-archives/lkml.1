Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYJQOLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYJQOLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYJQOKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:10:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:15660 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbYJQOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MYm8b4lobF+OGBSs6xI+mLTcOcXMaLCFJPiPTaoNHi4OgObvG7eIpdaOQe6aZZIRAP
         WUJAf0MmgaS5uKu7DJbFLd43sR3a9tsUaQ06yeFu8KsLkYmy6IL5qoBpYvykKAjI5ofI
         063hMPZTluDpJVZCCLAjgPeHm+Hkucof+Xw68=
Date: Fri, 17 Oct 2008 18:13:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init: Properly placing noinline keyword.
Message-ID: <20081017141354.GA9242@x200.localdomain>
References: <b9df5fa10810170605t50e366e9nf62f8a18df37fc3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10810170605t50e366e9nf62f8a18df37fc3c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 07:05:32PM +0600, Rakib Mullick wrote:
> Here, noinline keyword should be placed between storage class and type.

Why?

> --- linux-2.6-stable.orig/init/main.c
> +++ linux-2.6-stable/init/main.c
> @@ -457,7 +457,7 @@ static void __init setup_command_line(ch
>   * gcc-3.4 accidentally inlines this function, so use noinline.
>   */
> 
> -static void noinline __init_refok rest_init(void)
> +static noinline void __init_refok rest_init(void)
>  	__releases(kernel_lock)
>  {
>  	int pid;
> @@ -792,7 +792,7 @@ static void run_init_process(char *init_
>  /* This is a non __init function. Force it to be noinline otherwise gcc
>   * makes it inline to init() and it becomes part of init.text section
>   */
> -static int noinline init_post(void)
> +static noinline int init_post(void)
