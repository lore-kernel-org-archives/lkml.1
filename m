Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbZIIJYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbZIIJYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZIIJYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:24:03 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:59482 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZIIJYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:24:01 -0400
Date: Wed, 09 Sep 2009 18:24:04 +0900 (JST)
Message-Id: <20090909.182404.39170557.ryov@valinux.co.jp>
To: fchecconi@gmail.com
Cc: riel@redhat.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       akpm@linux-foundation.org, nauman@google.com,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090909000900.GK17468@gandalf.sssup.it>
References: <20090908.120119.71095369.ryov@valinux.co.jp>
	<4AA6AF58.3050501@redhat.com>
	<20090909000900.GK17468@gandalf.sssup.it>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Fabio Checconi <fchecconi@gmail.com> wrote:
> Hi,
> 
> > From: Rik van Riel <riel@redhat.com>
> > Date: Tue, Sep 08, 2009 03:24:08PM -0400
> >
> > Ryo Tsuruta wrote:
> > >Rik van Riel <riel@redhat.com> wrote:
> > 
> > >>Are you saying that dm-ioband is purposely unfair,
> > >>until a certain load level is reached?
> > >
> > >Not unfair, dm-ioband(weight policy) is intentionally designed to
> > >use bandwidth efficiently, weight policy tries to give spare bandwidth
> > >of inactive groups to active groups.
> > 
> > This sounds good, except that the lack of anticipation
> > means that a group with just one task doing reads will
> > be considered "inactive" in-between reads.
> > 
> 
>   anticipation helps in achieving fairness, but CFQ currently disables
> idling for nonrot+NCQ media, to avoid the resulting throughput loss on
> some SSDs.  Are we really sure that we want to introduce anticipation
> everywhere, not only to improve throughput on rotational media, but to
> achieve fairness too?

I'm also not sure if it's worth introducing anticipation everywhere.
The storage devices are becoming faster and smarter every year. In
practice, I did a benchmark with a SAN storage and the noop scheduler
got the best result.

However, I'll consider how IO from one task should take care of.

Thanks,
Ryo Tsuruta
