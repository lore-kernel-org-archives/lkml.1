Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbYEWUox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbYEWUox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYEWUoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:44:44 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:1600 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYEWUon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:44:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PDOysXTQe8LI5wCVbEQcZkfiAyelCIhbbu8bSZ4tP9RfP/7Bk1D2C7bpBy62IBvAWB4eY251w0ZoVuqhi9lwFOcQpXoGE0GqgymNcS3Md5MhKjpbWrO84JURKHxcZ2tfnyIKp2T5ojEkiaWOo0/xEIozex9EykBF0zyZFI4q6vE=
Message-ID: <c384c5ea0805231344j77f61941u229206d04c1ef948@mail.gmail.com>
Date: Fri, 23 May 2008 22:44:42 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Cc: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Magnus Damm" <magnus.damm@gmail.com>
In-Reply-To: <20080523135557.27fe4855@bluebox.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>
	 <20080523055527.GA28963@digi.com>
	 <20080523104454.4e2af6ec@bluebox.local>
	 <20080523091009.GA22821@digi.com>
	 <20080523120308.7bec1e1c@bluebox.local>
	 <20080523105604.GA23800@digi.com>
	 <20080523135557.27fe4855@bluebox.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 23, 2008 at 1:55 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> +static ssize_t uio_write(struct file *filep, const char __user *buf,
> +                       size_t count, loff_t *ppos)
> +{
> +       struct uio_listener *listener = filep->private_data;
> +       struct uio_device *idev = listener->dev;
> +       ssize_t retval;
> +       s32 irq_on;
> +
> +       if (idev->info->irq == UIO_IRQ_NONE)
> +               return -EIO;
> +
> +       if (count != sizeof(s32))
> +               return -EINVAL;
> +
> +       if (!idev->info->irqcontrol)
> +               return -ENOSYS;
> +
> +       if (copy_from_user(&irq_on, buf, count))
> +               return -EFAULT;
> +
> +       retval = idev->info->irqcontrol(idev->info, irq_on);
> +
> +       return retval ? retval : sizeof(s32);
> +}
> +

Shouldn't this be more future-proof, what if we need to abuse write()
for something else in the future?

I would suggest a check for ppos to be 0 (zero) as well, just to be
sure and future-proof and backwards-safe.

Regards,
-- 
Leon
