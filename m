Return-Path: <linux-kernel-owner+w=401wt.eu-S1762574AbYDKQYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762574AbYDKQYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762316AbYDKQXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:23:53 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:8797 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762308AbYDKQXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KGFTqFy9XnjQ3YJPWCLCGIQ/3i1E+Eg8XQI3k5Bw8rjZieZCCDlKKzvFUKqVi5frvqOC0bu900IkEhy23gOW1ESEK2v6WtQD+3AGBMzsusZ1HaZ2x7DZ+fQ6aHxVitCu+gouxnXTUkFqyrHGnZeDjJL08vIJr1mVivLYUyOyyFM=
Message-ID: <86802c440804110923m4a64bc26t8e83f16177ed094f@mail.gmail.com>
Date: Fri, 11 Apr 2008 09:23:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on free_irq
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Jeff Garzik" <jeff@garzik.org>,
       "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200804111719.44833.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
	 <1207899030.15605.1.camel@x61.ebiederm.org>
	 <alpine.LFD.1.10.0804111217450.3261@apollo.tec.linutronix.de>
	 <200804111719.44833.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 8:19 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Friday, 11 of April 2008, Thomas Gleixner wrote:
>  > On Fri, 11 Apr 2008, Eric W. Biederman wrote:
>  > > On Fri, 2008-04-11 at 00:17 -0700, Yinghai Lu wrote:
>  > > > On Fri, Apr 11, 2008 at 12:14 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  > > > > On Fri, Apr 11, 2008 at 12:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>  > > > >  > On Thu, 10 Apr 2008, Yinghai Lu wrote:
>  > > > >  >  > last week found:
>  > > > >  >  > after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
>  > > > >  >  > forcedeth doesn't work anymore.
>  > > > >  >  >
>  > > > >  >  > I stared at forcedeth.c two days. and revert every patches about that
>  > > > >  >  > doesn't help.
>  > > > >  >
>  > > > >  >  So forcedeth does not come up again, when you kexec from linus.git
>  > > > >  >  into an older distro kernel. Or is it the other way round ?
>  > > > >  RHEL 5.1 kexec RHEL 5.1 : works
>  > > > >  RHEL 5.1 kexec linus kernel: works
>  > > > >  linus (after -rc2) kexec linus tree: works:
>  > > > >  linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
>  > > > >  linus ( before -rc2 include rc2) kexec RHEL 5.1 works
>  > > > >
>  > > > the forcedeth can not get IP address...
>  > >
>  > > Sounds like you are not getting any interrupts when you receive a
>  > > packet.  (i.e. The interrupt line is staying disabled).
>  > >
>  > > Is MSI an option here?  I'm wondering if we disable the MSI and
>  > > something is not enabling it.
>  >
>  > Hmm, we disable the interrupt on free_irq(), but we reenable it in
>  > request_irq()/setup_irq(), which is called when the forcedeth driver
>  > initializes in the kexeced kernel. So there is some other deeper down
>  > problem lurking.
>  >
>  > Yinghai, can you apply that patch to RHEL 5.1 and check, what happens
>  > if you do:
>  >
>  > modprobe forcedeth
>  > ifup ...
>  > ifdown ...
>  > rmmod forcedeth
>  > modprobe forcedeth
>  > ifup ...
>  >
>  > This should result in the same problem, but probably simpler to debug.
>
>  I've just got a report from a forcedeth user that it doesn't work after a
>  resume from RAM for him any more.  Can it be related?

then another path that missing enable irq..

YH
