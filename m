Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYAMVZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYAMVZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 16:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYAMVZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 16:25:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:5702 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYAMVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 16:25:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H44nv64o9pp2DJx3tHaOxudq9WYdar6Zw9q1HtI44JXO0EubCvJeN2fXeu1QYFnJ9PENJnG40cHHePQsq1Dt/GR/LlllhoA7Ak2oFwMGKToNlbI/2zdXH+Qg1ugDhd4YVpH+G4YZalMiI18u/flqPoSiSS9bDT6bIY2lw8Sd5qY=
Message-ID: <aa79d98a0801131325l5cd5130fld21f5d475f49e419@mail.gmail.com>
Date: Mon, 14 Jan 2008 00:25:28 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
Cc: "Paul Gortmaker" <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>
In-Reply-To: <20080113210731.GA16066@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080113203223.GA6723@cvg>
	 <20080113210731.GA16066@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Alexey for review, i'll make it updated tomorrow. (sorry for top-post)

On 1/14/08, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Sun, Jan 13, 2008 at 11:32:23PM +0300, Cyrill Gorcunov wrote:
> > This patch converts ioctl call to unlocked_ioctl form with
> > explicit big-kernel-lock. Also it makes a bit of cleanup
> > converting miscdevice structure initialization to C99 form.
> >
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > ---
> >
> > Any comments are welcome.
> > This is untested code - i've no such chip on my laptop.
> >
> > Andi, i think we could use mutex to eliminate BKL, but not sure.
>
> Looks like it can be dropped here. All usage of rtc-> is done under
> rtc_lock. Every other variable there is thread-local.
>
