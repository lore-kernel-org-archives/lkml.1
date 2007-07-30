Return-Path: <linux-kernel-owner+w=401wt.eu-S967994AbXG3VWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967994AbXG3VWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966359AbXG3VWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:22:43 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49060 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765538AbXG3VWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:22:43 -0400
Subject: Re: [PATCH] add check do_direct_IO() return val
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Jin <joe.jin@oracle.com>, gurudas pai <gurudas.pai@oracle.com>,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       lkml <linux-kernel@vger.kernel.org>, wen.gang.wang@oracle.com,
       Zach Brown <zach.brown@oracle.com>
In-Reply-To: <20070730135316.2ce21b28.akpm@linux-foundation.org>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com>
	 <20070726221307.3d7b3446.akpm@linux-foundation.org>
	 <20070727071547.GA25084@joejin-pc.cn.oracle.com>
	 <46A9E6F9.20603@oracle.com>
	 <20070728034719.GA24448@joejin-pc.cn.oracle.com>
	 <20070730135316.2ce21b28.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 14:24:43 -0700
Message-Id: <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 13:53 -0700, Andrew Morton wrote:
> On Sat, 28 Jul 2007 11:47:19 +0800
> Joe Jin <joe.jin@oracle.com> wrote:
> 
> > > I tested Andrew's patch and panic was gone but got few ENOTBLK.
> > > So I tried with Joe's patch , both panic and ENOTBLK are gone now.
> > > But in Joe's patch if (ret == -ENOTBLK && (rw & WRITE)), dio_cleanup(dio)
> > > was not getting called because of break. So I moved dio_cleanup just 
> > > after if (ret).
> > 
> > Guru, actually, break from the loop with ENOTBLK will call dio_cleanup
> > at leater, if call it too early, that means will put_page(), maybe cause
> > other panic.
> > 
> 
> fyi, I dropped the earlier patch and now we have nothing.  Please let's get all
> this sorted out in time for 2.6.23.  Which is still many weeks away so there is
> plenty of time to prepare something which was carefully reviewed and well-tested,
> thanks.

I am also taking a look at it right now. Unfortunately, I don't think
fix is that simple - since we need to return success, in case of a
partial write.

Thanks,
Badari

