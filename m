Return-Path: <linux-kernel-owner+w=401wt.eu-S1751408AbXJUEHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbXJUEHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 00:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbXJUEGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 00:06:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50180 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXJUEGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 00:06:53 -0400
Date: Sat, 20 Oct 2007 21:06:41 -0700
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Oops: [RFC] LinuxPPS (pre)patch
Message-ID: <20071021040641.GB24869@kroah.com>
References: <20071019174113.GE20509@enneenne.com> <20071019175323.GA20453@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019175323.GA20453@enneenne.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 07:53:24PM +0200, Rodolfo Giometti wrote:
> +/* The main struct */
> +struct pps_device {
> +	struct pps_source_info info;		/* PSS source info */
> +
> +	struct pps_kparams params;		/* PPS's current params */
> +
> +	__u32 assert_sequence;			/* PPS' assert event seq # */
> +	__u32 clear_sequence;			/* PPS' clear event seq # */
> +	struct pps_ktime assert_tu;
> +	struct pps_ktime clear_tu;
> +	int current_mode;			/* PPS mode at event time */
> +
> +	int go;					/* PPS event is arrived? */
> +	wait_queue_head_t queue;		/* PPS event queue */
> +
> +	unsigned int id;			/* PPS source unique ID */
> +	struct cdev cdev;
> +	struct device *dev;
> +	int devno;
> +	struct fasync_struct *async_queue;	/* fasync method */
> +	spinlock_t lock;
> +
> +	atomic_t usage;				/* usage count */
> +	wait_queue_head_t usage_queue;
> +
> +	struct class_device class_dev;
> +};

Please use a 'struct class' instead of a 'struct class_device'.  We have
almost rid the kernel of all usages of 'struct class_device' and want to
remove that structure entirely soon.  I'm aiming for 2.6.25 and it's
looking good.

So please don't add new instances of it, you can do all the same things
with a 'struct device' and it should be a very trivial change.

thanks,

greg k-h
