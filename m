Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbZDLQpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbZDLQpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZDLQo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:44:56 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:40307 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZDLQoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bN/RVAZUBEMvPzD3obTcjNYOL6qthDQRELwEUXb5kjIOlTSSzrQEOc3WscGEdJXGrK
         d/6ZZ5oyQq8jxlrDU/8ZhOG2z68xBKe/6Q823Pkd1+TocQC6HAwJcNqQsLbxdnoKJ0BY
         qTEKBDlEhJobYpILnpMBljHDVKax38TSJcozM=
MIME-Version: 1.0
In-Reply-To: <1239365545-10356-8-git-send-email-philipp.reisner@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-2-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-3-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-4-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-5-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-6-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-7-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-8-git-send-email-philipp.reisner@linbit.com>
Date: Sun, 12 Apr 2009 18:44:53 +0200
Message-ID: <e2e108260904120944t1d0fec44yccbc50b6246988d0@mail.gmail.com>
Subject: Re: [PATCH 07/14] DRBD: internal_data_structures
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 2:12 PM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> diff -uNrp linux-2.6.30-rc1/drivers/block/drbd/drbd_int.h linux-2.6.30-rc1-drbd/drivers/block/drbd/drbd_int.h

...

> +#define PRINTK(level, fmt, args...) \
> +       printk(level "drbd%d: " fmt, \
> +               mdev->minor , ##args)

The above looks similar to dev_printk() from <linux/device.h>. It
would be great if some of the DRBD-specific macro's could be replaced
by existing Linux macro's. This would improve the readability of the
DRBD source code.

...

> +#define D_ASSERT(exp)  if (!(exp)) \
> +        ERR("ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
> +
> +#define ERR_IF(exp) if (({                             \
> +       int _b = (exp) != 0;                            \
> +       if (_b) ERR("%s: (%s) in %s:%d\n",              \
> +               __func__, #exp, __FILE__, __LINE__);    \
> +        _b;                                            \
> +       }))

How about replacing invocations of D_ASSERT() and/or ERR_IF() by WARN_ON() ?

Bart.
