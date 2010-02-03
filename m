Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab0BCP7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:59:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab0BCP7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:59:05 -0500
Date: Wed, 3 Feb 2010 10:58:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] [RFC] 512K readahead size with thrashing safe
	readahead
Message-ID: <20100203155845.GB17059@redhat.com>
References: <20100202152835.683907822@intel.com> <20100202223803.GF3922@redhat.com> <20100203062756.GB22890@localhost> <20100203152454.GA17059@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203152454.GA17059@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 10:24:54AM -0500, Vivek Goyal wrote:
> On Wed, Feb 03, 2010 at 02:27:56PM +0800, Wu Fengguang wrote:
> > Vivek,
> > 
> > On Wed, Feb 03, 2010 at 06:38:03AM +0800, Vivek Goyal wrote:
> > > On Tue, Feb 02, 2010 at 11:28:35PM +0800, Wu Fengguang wrote:
> > > > Andrew,
> > > > 
> > > > This is to lift default readahead size to 512KB, which I believe yields
> > > > more I/O throughput without noticeably increasing I/O latency for today's HDD.
> > > > 
> > > 
> > > Hi Fengguang,
> > > 
> > > I was doing a quick test with the patches. I was using fio to run some
> > > sequential reader threads. I have got one access to one Lun from an HP
> > > EVA. In my case it looks like with the patches throughput has come down.
> > 
> > Thank you for the quick testing!
> > 
> > This patchset does 3 things:
> > 
> > 1) 512K readahead size
> > 2) new readahead algorithms
> > 3) new readahead tracing/stats interfaces
> > 
> > (1) will impact performance, while (2) _might_ impact performance in
> > case of bugs.
> > 
> > Would you kindly retest the patchset with readahead size manually set
> > to 128KB?  That would help identify the root cause of the performance
> > drop:
> > 
> >         DEV=sda
> >         echo 128 > /sys/block/$DEV/queue/read_ahead_kb
> > 
> 
> I have got two paths to the HP EVA and got multipath device setup(dm-3). I
> noticed with vanilla kernel read_ahead_kb=128 after boot but with your patches
> applied it is set to 4. So looks like something went wrong with device
> size/capacity detection hence wrong defaults. Manually setting
> read_ahead_kb=512, got me better performance as compare to vanilla kernel.
> 

I put a printk in add_disk and noticed that for multipath device get_capacity() is returning 0 and that's why ra_pages is being set to 1.

Thanks
Vivek
