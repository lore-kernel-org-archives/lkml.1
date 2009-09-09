Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZIIAFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZIIAFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZIIAFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:05:43 -0400
Received: from ms01.sssup.it ([193.205.80.99]:59765 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751822AbZIIAFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:05:43 -0400
Date: Wed, 9 Sep 2009 02:09:00 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, vgoyal@redhat.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
Message-ID: <20090909000900.GK17468@gandalf.sssup.it>
References: <20090904231129.GA3689@redhat.com> <20090907.200222.193693062.ryov@valinux.co.jp> <4AA51065.6050000@redhat.com> <20090908.120119.71095369.ryov@valinux.co.jp> <4AA6AF58.3050501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA6AF58.3050501@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Rik van Riel <riel@redhat.com>
> Date: Tue, Sep 08, 2009 03:24:08PM -0400
>
> Ryo Tsuruta wrote:
> >Rik van Riel <riel@redhat.com> wrote:
> 
> >>Are you saying that dm-ioband is purposely unfair,
> >>until a certain load level is reached?
> >
> >Not unfair, dm-ioband(weight policy) is intentionally designed to
> >use bandwidth efficiently, weight policy tries to give spare bandwidth
> >of inactive groups to active groups.
> 
> This sounds good, except that the lack of anticipation
> means that a group with just one task doing reads will
> be considered "inactive" in-between reads.
> 

  anticipation helps in achieving fairness, but CFQ currently disables
idling for nonrot+NCQ media, to avoid the resulting throughput loss on
some SSDs.  Are we really sure that we want to introduce anticipation
everywhere, not only to improve throughput on rotational media, but to
achieve fairness too?
