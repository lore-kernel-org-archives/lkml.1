Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYAMVHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYAMVHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 16:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYAMVHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 16:07:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:25273 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYAMVHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 16:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=btOIomb0A7nmAy7vm2Q8u8LnqXotYp43XUU74yInY0XXje4j5DhCuVi6PqcC4VYw4umIyV31XpCaM1oSD2y44ZQr371sSQFw2mi7maEJbtApR5SCX0TwGz+WxR4+J2UlKXHIyKgc8VBKaj08LFJO8CnsEx7wJft22WCSW6yuWq8=
Date: Mon, 14 Jan 2008 00:07:31 +0300
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
Message-ID: <20080113210731.GA16066@martell.zuzino.mipt.ru>
References: <20080113203223.GA6723@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113203223.GA6723@cvg>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 11:32:23PM +0300, Cyrill Gorcunov wrote:
> This patch converts ioctl call to unlocked_ioctl form with
> explicit big-kernel-lock. Also it makes a bit of cleanup
> converting miscdevice structure initialization to C99 form.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Any comments are welcome.
> This is untested code - i've no such chip on my laptop.
> 
> Andi, i think we could use mutex to eliminate BKL, but not sure.

Looks like it can be dropped here. All usage of rtc-> is done under
rtc_lock. Every other variable there is thread-local.
