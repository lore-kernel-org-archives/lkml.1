Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbXGQKEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbXGQKEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 06:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXGQKEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 06:04:12 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:33803 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbXGQKEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 06:04:09 -0400
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
From: Kalpak Shah <kalpak@clusterfs.com>
To: cmm@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
In-Reply-To: <1184633395.3836.24.camel@localhost.localdomain>
References: <1183275416.4010.125.camel@localhost.localdomain>
	 <20070710163027.1bf7e94e.akpm@linux-foundation.org>
	 <1184633395.3836.24.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 15:29:30 +0530
Message-Id: <1184666370.7063.13.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SystemSpamProbe: GOOD 0.0002340 be729ed656ece32005d11099bc5e6a5f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-16 at 17:49 -0700, Mingming Cao wrote:
> On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> > On Sun, 01 Jul 2007 03:36:56 -0400
> > Mingming Cao <cmm@us.ibm.com> wrote:
> > > +static inline __le32 ext4_encode_extra_time(struct timespec *time)
> > > +{
> > > +       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
> > > +			   time->tv_sec >> 32 : 0) |
> > > +			   ((time->tv_nsec << 2) & EXT4_NSEC_MASK));
> > > +}
> > > +
> > > +static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
> > > +{
> > > +       if (sizeof(time->tv_sec) > 4)
> > > +	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
> > > +			       << 32;
> > > +       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
> > > +}
> > 
> > Consider uninlining these functions.
> > 
> I got compile warining after apply Kalpal's update nanosecond patch,
> which makes these two function inline. It complains these functions are
> defined but not used. It's being used only in the following
> micros(EXT4_INODE_SET_XTIME etc).  So if the .c file included the
> ext4_fs.h but not using the micros, the compile will think these two
> functions are not used.

The compile warnings were introduced because the functions were
uninlined. So we can either keep these functions inlined or consider
adding a "__used" attribute to these two functions. 

Thanks,
Kalpak.

