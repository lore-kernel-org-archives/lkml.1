Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZGMMwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZGMMwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 08:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZGMMwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 08:52:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:26841 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbZGMMwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 08:52:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,390,1243839600"; 
   d="scan'208";a="164360573"
Date: Mon, 13 Jul 2009 20:52:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ronald Moesbergen <intercommit@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090713125208.GA1629@localhost>
References: <a0272b440907062349k24041e74sbb1776ab3e172c58@mail.gmail.com> <4A5395FD.2040507@vlnb.net> <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com> <4A5493A8.2000806@vlnb.net> <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com> <4A56FF32.2060303@vlnb.net> <4A570981.5080803@vlnb.net> <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com> <20090713123621.GA31051@localhost> <a0272b440907130547x2fb6fbc6g4764e61cb7ba9fff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0272b440907130547x2fb6fbc6g4764e61cb7ba9fff@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 08:47:31PM +0800, Ronald Moesbergen wrote:
> 2009/7/13 Wu Fengguang <fengguang.wu@intel.com>:
> > On Mon, Jul 13, 2009 at 08:12:14PM +0800, Ronald Moesbergen wrote:
> >> 2009/7/10 Vladislav Bolkhovitin <vst@vlnb.net>:
> >> >
> >> > Vladislav Bolkhovitin, on 07/10/2009 12:43 PM wrote:
> >> >>
> >> >> Ronald Moesbergen, on 07/10/2009 10:32 AM wrote:
> >> >>>>
> >> >>>> I've also long ago noticed that reading data from block devices is
> >> >>>> slower
> >> >>>> than from files from mounted on those block devices file systems. Can
> >> >>>> anybody explain it?
> >> >>>>
> >> >>>> Looks like this is strangeness #2 which we uncovered in our tests (the
> >> >>>> first
> >> >>>> one was earlier in this thread why the context RA doesn't work with
> >> >>>> cooperative I/O threads as good as it should).
> >> >>>>
> >> >>>> Can you rerun the same 11 tests over a file on the file system, please?
> >> >>>
> >> >>> I'll see what I can do. Just te be sure: you want me to run
> >> >>> blockdev-perftest on a file on the OCFS2 filesystem which is mounted
> >> >>> on the client over iScsi, right?
> >> >>
> >> >> Yes, please.
> >> >
> >> > Forgot to mention that you should also configure your backend storage as a
> >> > big file on a file system (preferably, XFS) too, not as direct device, like
> >> > /dev/vg/db-master.
> >>
> >> Ok, here are the results:
> >
> > Ronald, thanks for the numbers!
> 
> You're welcome.
> 
> >> client kernel: 2.6.26-15lenny3 (debian)
> >> server kernel: 2.6.29.5 with readahead patch
> >
> > Do you mean the context readahead patch?
> 
> No, I meant the blk_run_backing_dev patch. The patchnames are
> confusing, I'll be sure to clarify them from now on.

That's OK.  I did see previous benchmarks were not helped by context
readahead noticeably on CFQ, hehe.

Thanks,
Fengguang
