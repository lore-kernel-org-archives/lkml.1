Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYCUDvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYCUDvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 23:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYCUDuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 23:50:55 -0400
Received: from hs-out-0708.google.com ([64.233.178.243]:2992 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYCUDuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 23:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lscRDoAM3JFOLZ8/rUNc5GFLul/psYkwyQwm8q57k9BZFESsry42SV3Jt3f5TX42TGrSwvyQ9pGPoWh+yls3bzBjnSVhxrkR9YMBsDIeFbafKHLw92FqNy4qWJ+x76BWpkKdHKADxPeXK/40w1J8fK5Y6L7TZPWI+tz5MoUnVX8=
Message-ID: <3ae72650803202050y14cb890bjce643d933dec1cb5@mail.gmail.com>
Date: Fri, 21 Mar 2008 04:50:51 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Rodolfo Giometti" <giometti@linux.it>
Subject: Re: [PATCH 1/7] LinuxPPS core support.
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Jones" <davej@redhat.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Greg KH" <greg@kroah.com>, "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <12048053473401-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12048053463198-git-send-email-giometti@linux.it>
	 <12048053473401-git-send-email-giometti@linux.it>
X-Google-Sender-Auth: 85ed5ec4ed306254
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 1:09 PM, Rodolfo Giometti <giometti@linux.it> wrote:
> This patch adds the kernel side of the PPS support currently named
>  "LinuxPPS".

>  diff --git a/include/linux/pps.h b/include/linux/pps.h
>  new file mode 100644
>  index 0000000..c455443
>  --- /dev/null
>  +++ b/include/linux/pps.h
>  @@ -0,0 +1,204 @@

>  +/* The main struct */
>  +struct pps_device {
>  +       struct pps_source_info info;            /* PSS source info */
>  +
>  +       struct pps_kparams params;              /* PPS's current params */
>  +
>  +       __u32 assert_sequence;                  /* PPS' assert event seq # */
>  +       __u32 clear_sequence;                   /* PPS' clear event seq # */
>  +       struct pps_ktime assert_tu;
>  +       struct pps_ktime clear_tu;
>  +       int current_mode;                       /* PPS mode at event time */
>  +
>  +       int go;                                 /* PPS event is arrived? */
>  +       wait_queue_head_t queue;                /* PPS event queue */
>  +
>  +       unsigned int id;                        /* PPS source unique ID */
>  +       struct cdev cdev;
>  +       struct device *dev;
>  +       int devno;
>  +       struct fasync_struct *async_queue;      /* fasync method */
>  +       spinlock_t lock;
>  +
>  +       atomic_t usage;                         /* usage count */
>  +       wait_queue_head_t usage_queue;
>  +
>  +       struct class class_dev;

Why is an entire class embedded into every device? :)

Kay
