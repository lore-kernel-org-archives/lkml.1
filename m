Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbYCURCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbYCURCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbYCURCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:02:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:57512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbYCURC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:02:29 -0400
Subject: Re: [PATCH 1/7] LinuxPPS core support.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20080321105759.GB8959@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it>
	 <12048053473401-git-send-email-giometti@linux.it>
	 <3ae72650803202050y14cb890bjce643d933dec1cb5@mail.gmail.com>
	 <20080321105759.GB8959@enneenne.com>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 18:01:45 +0100
Message-Id: <1206118905.24338.10.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ADXfSqqUQfk5FRwwDasBkxo1ukTdI1zi3hF0
 h/nmJdVmx4DT0hxoxtA2Uq7kx+BolLb54B5yCP42RHwvMJ0can
 OFHHFnxKfWQlgg4/ka5FSDWTOx+9Fo7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 11:57 +0100, Rodolfo Giometti wrote:
> On Fri, Mar 21, 2008 at 04:50:51AM +0100, Kay Sievers wrote:
> > On Thu, Mar 6, 2008 at 1:09 PM, Rodolfo Giometti <giometti@linux.it> wrote:
> > > This patch adds the kernel side of the PPS support currently named
> > >  "LinuxPPS".
> > 
> > >  diff --git a/include/linux/pps.h b/include/linux/pps.h
> > >  new file mode 100644
> > >  index 0000000..c455443
> > >  --- /dev/null
> > >  +++ b/include/linux/pps.h
> > >  @@ -0,0 +1,204 @@
> > 
> > >  +/* The main struct */
> > >  +struct pps_device {
> > >  +       struct pps_source_info info;            /* PSS source info */
> > >  +
> > >  +       struct pps_kparams params;              /* PPS's current params */
> > >  +
> > >  +       __u32 assert_sequence;                  /* PPS' assert event seq # */
> > >  +       __u32 clear_sequence;                   /* PPS' clear event seq # */
> > >  +       struct pps_ktime assert_tu;
> > >  +       struct pps_ktime clear_tu;
> > >  +       int current_mode;                       /* PPS mode at event time */
> > >  +
> > >  +       int go;                                 /* PPS event is arrived? */
> > >  +       wait_queue_head_t queue;                /* PPS event queue */
> > >  +
> > >  +       unsigned int id;                        /* PPS source unique ID */
> > >  +       struct cdev cdev;
> > >  +       struct device *dev;
> > >  +       int devno;
> > >  +       struct fasync_struct *async_queue;      /* fasync method */
> > >  +       spinlock_t lock;
> > >  +
> > >  +       atomic_t usage;                         /* usage count */
> > >  +       wait_queue_head_t usage_queue;
> > >  +
> > >  +       struct class class_dev;
> > 
> > Why is an entire class embedded into every device? :)
> 
> Uh! =:-o
> 
> Is that not right? What do you suggest to do?

It looks wrong. Do you use it for anything? I guess, you can just remove
it.

Kay

