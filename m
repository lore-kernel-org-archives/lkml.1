Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYHGTc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYHGTc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbYHGTcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:32:50 -0400
Received: from gw.goop.org ([64.81.55.164]:37865 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYHGTct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:32:49 -0400
Message-ID: <489B4DD0.8080607@goop.org>
Date: Thu, 07 Aug 2008 12:32:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: removes extra assignment from arch/x86/kernel/ldt.c
References: <b9df5fa10808060633j6c1db8e4haa5dc5fd549e7b08@mail.gmail.com>
In-Reply-To: <b9df5fa10808060633j6c1db8e4haa5dc5fd549e7b08@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib Mullick wrote:
> Hello guys, this patch removes an extra assignment from "write_ldt" function.
> Thanks.
>
> Signed-off-by : Md.Rakib H. Mullick (rakib.mullick@gmail.com)
>
> --- linux-2.6.27-rc2.orig/arch/x86/kernel/ldt.c	2008-08-06
> 16:23:53.000000000 +0600
> +++ linux-2.6.27-rc2/arch/x86/kernel/ldt.c	2008-08-06 19:18:50.984268144 +0600
> @@ -191,11 +191,12 @@ static int write_ldt(void __user *ptr, u
>  	error = -EINVAL;
>  	if (bytecount != sizeof(ldt_info))
>  		goto out;
> -	error = -EFAULT;
> -	if (copy_from_user(&ldt_info, ptr, sizeof(ldt_info)))
> +
> +	if (copy_from_user(&ldt_info, ptr, sizeof(ldt_info))) {
> +		error = -EFAULT;
>  		goto out;
> +	}
>   

It would be better to move the EFAULT check up above so the EINVAL 
checks are adjacent.

    J
