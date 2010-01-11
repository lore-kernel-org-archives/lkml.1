Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475Ab0AKNNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0AKNNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258Ab0AKNNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:13:19 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37231 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab0AKNNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:13:18 -0500
Date: Mon, 11 Jan 2010 14:13:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: NCQ SSDs do not need read queue merging
Message-ID: <20100111131317.GB4489@kernel.dk>
References: <1262211768-10858-1-git-send-email-czoccolo@gmail.com> <1263157461-12294-1-git-send-email-czoccolo@gmail.com> <4B4B0AA9.5020900@garzik.org> <4e5e476b1001110426t2afa0502p7f19a9b24e48ba82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b1001110426t2afa0502p7f19a9b24e48ba82@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11 2010, Corrado Zoccolo wrote:
> On Mon, Jan 11, 2010 at 12:25 PM, Jeff Garzik <jeff@garzik.org> wrote:
> > On 01/10/2010 04:04 PM, Corrado Zoccolo wrote:
> >>
> >> NCQ SSDs' performances are not affected by
> >> distance of read requests, so there is no point in having
> >> overhead to merge such queues.
> >>
> >> Non-NCQ SSDs showed regression in some special cases, so
> >> they are ruled out by this patch.
> >>
> >> This patch intentionally doesn't affect writes, so
> >> it changes the queued[] field, to be indexed by
> >> READ/WRITE instead of SYNC/ASYNC, and only compute proximity
> >> for queues with WRITE requests.
> >>
> >> Signed-off-by: Corrado Zoccolo<czoccolo@gmail.com>
> >
> > That's not really true.  Overhead always increases as the total number of
> > ATA commands issued increases.
> 
> Jeff Moyer tested the patch on the workload that mostly benefit of
> queue merging, and found that
> the performance was improved by the patch.
> So removing the CPU overhead helps much more than the marginal gain
> given by merging on this hardware.

It's not always going to be true. On SATA the command overhead is fairly
low, but on other hardware that may not be the case. Unless you are CPU
bound by your IO device, then merging will always be beneficial. I'm a
little behind on emails after my vacation, Jeff what numbers did you
generate and on what hardware?

-- 
Jens Axboe

