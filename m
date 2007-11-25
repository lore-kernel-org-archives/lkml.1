Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbXKYO2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbXKYO2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 09:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXKYO2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 09:28:44 -0500
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:33867
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbXKYO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 09:28:43 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2007 09:28:43 EST
X-Authority-Analysis: v=1.0 c=1 a=Z71ycb1IQu275o0qYpcA:9 a=IuRmtarkJDWGaABYS6EA:7 a=Ty4-RnrND4soOfLrmSDvO_p5HAwA:4 a=50e4U0PicR4A:10
Subject: Re: Linux 2.6.22.14
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20071121175701.GB1329@kroah.com>
References: <20071121175644.GA1329@kroah.com>
	 <20071121175701.GB1329@kroah.com>
Content-Type: text/plain
Date: Sun, 25 Nov 2007 06:21:35 -0800
Message-Id: <1196000495.18901.8.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I think this hunk in the 2.6.22.14 stable patch may be a mis-patch --
compared to Linus's current git -- the new code should be inserted below
the while loop that follows.

Also see commit 9f96cb1e8bca179a92afa40dfc3c49990f1cfc71

Sven

On Wed, 2007-11-21 at 09:57 -0800, Greg Kroah-Hartman wrote:
> @@ -61,18 +70,23 @@ void compat_exit_robust_list(struct task_struct
> *curr)
>         if (fetch_robust_entry(&upending, &pending,
>                                &head->list_op_pending, &pip))
>                 return;
> -       if (pending)
> -               handle_futex_death((void __user *)pending +
> futex_offset, curr, pip);
> +       if (pending) {
> +               void __user *uaddr = futex_uaddr(pending,
> +                                                futex_offset);
> +               handle_futex_death(uaddr, curr, pip);
> +       }

