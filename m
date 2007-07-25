Return-Path: <linux-kernel-owner+w=401wt.eu-S934452AbXGYTM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452AbXGYTM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbXGYTMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:12:17 -0400
Received: from mx28.mail.ru ([194.67.23.67]:32967 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758625AbXGYTMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:12:16 -0400
Date: Wed, 25 Jul 2007 23:14:37 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: wli@holomorphy.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add in SunOS 4.1.x compatible mode for UFS
Message-ID: <20070725191437.GA29943@rain>
Mail-Followup-To: Mark Fortescue <mark@mtfhpc.demon.co.uk>,
	wli@holomorphy.com, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.61.0707251718380.20510@mtfhpc.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0707251718380.20510@mtfhpc.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.

Just a few minor things:

On Wed, Jul 25, 2007 at 06:27:46PM +0100, Mark Fortescue wrote:
> Macros have been put in to alow suport for the old static table Cylinder 
> Groups
> but this implementation does not use them yet.

But why add them to patch?
 
> +	/* Sort out mod used on SunOS 4.1.3 for fs_state */
> +	uspi->s_postblformat = fs32_to_cpu(sb, usb3->fs_postblformat);
> +	if (((flags & UFS_ST_MASK) == UFS_ST_SUNOS) &&
> +	    (uspi->s_postblformat != UFS_42POSTBLFMT))
> +	{
> +	    flags &= ~UFS_ST_MASK;
> +	    flags |=  UFS_ST_SUN;
> +	}
> +
>  

Documentation/CodingStyle: if () {

>  	switch (UFS_SB(sb)->s_flags & UFS_ST_MASK) {
> +	case UFS_ST_SUNOS:
> +		if (fs32_to_cpu(sb, usb3->fs_postblformat == UFS_42POSTBLFMT))

Really should be so?
May be you mean:
fs32_to_cpu(sb, usb3->fs_postblformat) == UFS_42POSTBLFMT ?
                                     ^


-- 
/Evgeniy

