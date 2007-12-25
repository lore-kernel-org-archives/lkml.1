Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXLYMVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXLYMVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 07:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbXLYMVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 07:21:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39347 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750868AbXLYMVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 07:21:08 -0500
Date: Tue, 25 Dec 2007 13:19:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Julia Lawall <julia@diku.dk>
Cc: rth@twiddle.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/38] arch/alpha: Use time_before, time_before_eq, etc.
Message-ID: <20071225121923.GB31662@elf.ucw.cz>
References: <Pine.LNX.4.64.0712241516010.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712241516010.23999@ask.diku.dk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-12-24 15:16:46, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The functions time_before, time_before_eq, time_after, and time_after_eq
> are more robust for comparing jiffies against other values.
> 
> A simplified version of the semantic patch making this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @ change_compare_np @
> expression E;
> @@
> 
> (
> - jiffies <= E
> + time_before_eq(jiffies,E)
> |
> - jiffies >= E
> + time_after_eq(jiffies,E)
> |
> - jiffies < E
> + time_before(jiffies,E)
> |
> - jiffies > E
> + time_after(jiffies,E)
> )

Maybe you should create new macro so that you don't have to pass the
jiffies all the time?

>  	if (!test_thread_flag (TIF_UAC_NOPRINT)) {
> -		if (cnt >= 5 && jiffies - last_time > 5*HZ) {
> +		if (cnt >= 5 && time_after(jiffies, last_time + 5*HZ)) {

			     && time_after_now(last_time + 5*HZ)

or something?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
