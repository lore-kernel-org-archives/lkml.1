Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0BYN4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:56:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606Ab0BYN4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:56:52 -0500
Date: Thu, 25 Feb 2010 14:55:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueues: microoptimize set_wq_data()
Message-ID: <20100225135547.GA6062@redhat.com>
References: <20100224202035.GA26991@redhat.com> <4B85EA24.5020409@kernel.org> <4B8650A2.9060803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8650A2.9060803@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/25, Tejun Heo wrote:
>
> Hello, again.
>
> On 02/25/2010 12:10 PM, Tejun Heo wrote:
> >> @@ -220,12 +220,9 @@ struct cpu_workqueue_struct *wq_per_cpu(
> >>  static inline void set_wq_data(struct work_struct *work,
> >>  				struct cpu_workqueue_struct *cwq)
> >>  {
> >> -	unsigned long new;
> >> -
> >> -	BUG_ON(!work_pending(work));
> >> -
> >> -	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
> >> +	unsigned long new = (unsigned long)cwq;
> >>  	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
> >> +	BUG_ON(!(new & (1UL << WORK_STRUCT_PENDING)));
> >>  	atomic_long_set(&work->data, new);
> >
> > Will apply under cmwq patches for the next merge window.
>
> Turns out I already have a patch which kills the second
> work_data_bits() dereferencing in the series.  The first one is now in
> the cmwq series which is about to be posted again.

OK, good.

Tejun, where can I find your cmwq patches? I'd like to take a look.

Thanks,

Oleg.

