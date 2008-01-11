Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbYAKIeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbYAKIeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYAKIeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:34:00 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2461 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754781AbYAKId7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:33:59 -0500
Date: Fri, 11 Jan 2008 08:33:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080111083345.GA3863@ucw.cz>
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Andi,
> I grepped and tried to do what you suggested.
> The first file that git grep reported was:
> arch/arm/common/rtctime.c:static const struct file_operations rtc_fops = {
> 
> So I cooked up the following patch (probably mangled, just to give you
> a rough idea of what I did):
> diff --git a/arch/arm/common/rtctime.c b/arch/arm/common/rtctime.c
> index bf1075e..19dedb5 100644
> --- a/arch/arm/common/rtctime.c
> +++ b/arch/arm/common/rtctime.c
> @@ -189,13 +189,16 @@ static int rtc_ioctl(struct inode *inode, struct
> file *file, unsigned int cmd,
>  		if (ret)
>  			break;
>  		ret = copy_to_user(uarg, &alrm.time, sizeof(tm));
> -		if (ret)
> +		if (ret) {
> +			unlock_kernel();
>  			ret = -EFAULT;
> +		}
>  		break;

Just put unlock kernel near return ret;...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
