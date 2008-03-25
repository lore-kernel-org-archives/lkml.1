Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYCYKyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYCYKyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYCYKxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:53:54 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:41430 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYCYKxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:53:53 -0400
Date: Tue, 25 Mar 2008 11:53:37 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Message-ID: <20080325105337.GF8959@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it> <12048053473401-git-send-email-giometti@linux.it> <3ae72650803202050y14cb890bjce643d933dec1cb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650803202050y14cb890bjce643d933dec1cb5@mail.gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/7] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 04:50:51AM +0100, Kay Sievers wrote:
> On Thu, Mar 6, 2008 at 1:09 PM, Rodolfo Giometti <giometti@linux.it> wrote:
> > This patch adds the kernel side of the PPS support currently named
> >  "LinuxPPS".
> 
> >  diff --git a/include/linux/pps.h b/include/linux/pps.h
> >  new file mode 100644
> >  index 0000000..c455443
> >  --- /dev/null
> >  +++ b/include/linux/pps.h
> >  @@ -0,0 +1,204 @@
> 
> >  +/* The main struct */
> >  +struct pps_device {
> >  +       struct pps_source_info info;            /* PSS source info */
> >  +
> >  +       struct pps_kparams params;              /* PPS's current params */
> >  +
> >  +       __u32 assert_sequence;                  /* PPS' assert event seq # */
> >  +       __u32 clear_sequence;                   /* PPS' clear event seq # */
> >  +       struct pps_ktime assert_tu;
> >  +       struct pps_ktime clear_tu;
> >  +       int current_mode;                       /* PPS mode at event time */
> >  +
> >  +       int go;                                 /* PPS event is arrived? */
> >  +       wait_queue_head_t queue;                /* PPS event queue */
> >  +
> >  +       unsigned int id;                        /* PPS source unique ID */
> >  +       struct cdev cdev;
> >  +       struct device *dev;
> >  +       int devno;
> >  +       struct fasync_struct *async_queue;      /* fasync method */
> >  +       spinlock_t lock;
> >  +
> >  +       atomic_t usage;                         /* usage count */
> >  +       wait_queue_head_t usage_queue;
> >  +
> >  +       struct class class_dev;
> 
> Why is an entire class embedded into every device? :)

Fixed, I'll provide a new patch ASAP.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
