Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472Ab0AVIoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0AVIoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 03:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382Ab0AVIoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 03:44:10 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:47512 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0AVIoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 03:44:05 -0500
Date: Fri, 22 Jan 2010 09:44:03 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [2.6.33-rc4] sysfs lockdep warnings on cpu hotplug
Message-ID: <20100122084402.GA6412@osiris.boeblingen.de.ibm.com>
References: <20100121155335.GB4471@osiris.boeblingen.de.ibm.com>
 <2375c9f91001212042y6dceee1bl54bc564dea54f11b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f91001212042y6dceee1bl54bc564dea54f11b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 12:42:22PM +0800, Américo Wang wrote:
> On Thu, Jan 21, 2010 at 11:53 PM, Heiko Carstens
> <heiko.carstens@de.ibm.com> wrote:
> > Hi Eric,
> >
> > rumours are that you could be responsible for the following lockdep message:
> >
> > Happens on cpu hotplug on s390:
> >
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.33-rc4-00399-g24bc734 #1
> > ---------------------------------------------
> > bash/2576 is trying to acquire lock:
> >  (s_active){++++.+}, at: [<000000000016c506>] sysfs_addrm_finish+0x5a/0xa8
> >
> > but task is already holding lock:
> >  (s_active){++++.+}, at: [<000000000016c90c>] sysfs_get_active_two+0x64/0x88
> >
> > other info that might help us debug this:
> > 5 locks held by bash/2576:
> >  #0:  (&buffer->mutex){+.+.+.}, at: [<000000000016a912>] sysfs_write_file+0x4a/0x1a8
> >  #1:  (s_active){++++.+}, at: [<000000000016c90c>] sysfs_get_active_two+0x64/0x88
> >  #2:  (s_active){++++.+}, at: [<000000000016c8e6>] sysfs_get_active_two+0x3e/0x88
> >  #3:  (cpu_add_remove_lock){+.+.+.}, at: [<00000000003dd318>] cpu_down+0x44/0x88
> >  #4:  (cpu_hotplug.lock){+.+.+.}, at: [<0000000000056eee>] cpu_hotplug_begin+0x3e/0x74
> >
> 
> I think this is the same with the problem we met some days ago,
> 
> http://lkml.org/lkml/2010/1/10/282
> 
> does this patch from Erich help?

No, it doesn't help.
