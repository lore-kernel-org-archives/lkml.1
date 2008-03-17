Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYCQWU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYCQWU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYCQWUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:20:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374AbYCQWUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:20:51 -0400
Date: Mon, 17 Mar 2008 15:18:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 8/8] handle leap second via timer
Message-Id: <20080317151856.adea0488.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0803150417540.1791@scrub.home>
References: <20080314184001.695807682@linux-m68k.org>
	<20080314195737.212526899@linux-m68k.org>
	<1205526244.6122.5.camel@localhost.localdomain>
	<Pine.LNX.4.64.0803150417540.1791@scrub.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar 2008 04:18:39 +0100 (CET)
Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Fri, 14 Mar 2008, john stultz wrote:
> 
> > Instead of exporting the clocksource making it global, could you use a
> > timekeeping_insert/remove_second() style interface?
> 
> Sounds good.
> 

It sounds like a few updates are in the pipeline, but I merged this series
as-is into -mm.

I'll normally push ntp changes through Thomas's git-hrt tree, however this
patch series has dependencies upon at least

introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64.patch
rename-div64_64-to-div64_u64-mm.patch
remove-div_long_long_rem.patch

so they can't go into git-hrt immediately.

The idealised algorithm is

- 2.6.26 opens
- Thomas merges git-hrt
- I merge the above patches
- I then send these ntp patches to Thomas
- He merges them into git-hrt
- He does another git-hrt -> Linus merge

And that's all OK, but various lags might cause us to miss the merge
window, as I merge the -mm stuff last, and some git-tree maintainers are
dawdlers.

So if Thomas wants to ack these I can merge them directly late in the
2.6.26 merge window.

