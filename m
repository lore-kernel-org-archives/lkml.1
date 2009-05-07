Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbZEGAXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbZEGAXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZEGAXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:23:23 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:60784 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753332AbZEGAXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:23:22 -0400
Date: Thu, 07 May 2009 09:23:22 +0900 (JST)
Message-Id: <20090507.092322.71121515.ryov@valinux.co.jp>
To: lizf@cn.fujitsu.com
Cc: Alan.Brunelle@hp.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <49FE5FEB.6040207@cn.fujitsu.com>
References: <49F23379.4010607@hp.com>
	<20090427.184417.189717449.ryov@valinux.co.jp>
	<49FE5FEB.6040207@cn.fujitsu.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
Date: Mon, 04 May 2009 11:24:27 +0800

> Ryo Tsuruta wrote:
> > Hi Alan,
> > 
> >> Hi Ryo -
> >>
> >> I don't know if you are taking in patches, but whilst trying to uncover
> >> some odd behavior I added some blktrace messages to dm-ioband-ctl.c. If
> >> you're keeping one code base for old stuff (2.6.18-ish RHEL stuff) and
> >> upstream you'll have to #if around these (the blktrace message stuff
> >> came in around 2.6.26 or 27 I think).
> >>
> >> My test case was to take a single 400GB storage device, put two 200GB
> >> partitions on it and then see what the "penalty" or overhead for adding
> >> dm-ioband on top. To do this I simply created an ext2 FS on each
> >> partition in parallel (two processes each doing a mkfs to one of the
> >> partitions). Then I put two dm-ioband devices on top of the two
> >> partitions (setting the weight to 100 in both cases - thus they should
> >> have equal access).
> >>
> >> Using default values I was seeing /very/ large differences - on the
> >> order of 3X. When I bumped the number of tokens to a large number
> >> (10,240) the timings got much closer (<2%). I have found that using
> >> weight-iosize performs worse than weight (closer to 5% penalty).
> > 
> > I could reproduce similar results. One dm-ioband device seems to stop
> > issuing I/Os for a few seconds at times. I'll investigate more on that.
> >  
> >> I'll try to formalize these results as I go forward and report out on
> >> them. In any event, I thought I'd share this patch with you if you are
> >> interested...
> > 
> > Thanks. I'll include your patche into the next release.
> >  
> 
> IMO we should use TRACE_EVENT instead of adding new blk_add_trace_msg().

Thanks for your suggestion. I'll use TRACE_EVENT instead.

> 
> >> Here's a sampling from some blktrace output (sorry for the wrapping) - I
> >> should note that I'm a bit scared to see such large numbers of holds
> >> going on when the token count should be >5,000 for each device...
> >> Holding these back in an equal access situation is inhibiting the block
> >> I/O layer to merge (most) of these (as mkfs performs lots & lots of
> >> small but sequential I/Os).
> 

Thanks,
Ryo Tsuruta
