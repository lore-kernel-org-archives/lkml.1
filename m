Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbZHQFNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbZHQFNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZHQFNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:13:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34010 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZHQFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:13:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 17 Aug 2009 14:11:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: ngupta@vflare.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swap: send callback when swap slot is freed
Message-Id: <20090817141143.50091cd1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A88E5CC.6050706@vflare.org>
References: <200908122007.43522.ngupta@vflare.org>
	<20090817115529.59395cea.kamezawa.hiroyu@jp.fujitsu.com>
	<4A88E5CC.6050706@vflare.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 10:38:28 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> On 08/17/2009 08:25 AM, KAMEZAWA Hiroyuki wrote:
> > On Wed, 12 Aug 2009 20:07:43 +0530
> > Nitin Gupta<ngupta@vflare.org>  wrote:
> >
> >> Currently, we have "swap discard" mechanism which sends a discard bio request
> >> when we find a free cluster during scan_swap_map(). This callback can come a
> >> long time after swap slots are actually freed.
> >>
> >> This delay in callback is a great problem when (compressed) RAM [1] is used
> >> as a swap device. So, this change adds a callback which is called as
> >> soon as a swap slot becomes free. For above mentioned case of swapping
> >> over compressed RAM device, this is very useful since we can immediately
> >> free memory allocated for this swap page.
> >>
> >> This callback does not replace swap discard support. It is called with
> >> swap_lock held, so it is meant to trigger action that finishes quickly.
> >> However, swap discard is an I/O request and can be used for taking longer
> >> actions.
> >>
> >> Links:
> >> [1] http://code.google.com/p/compcache/
> >>
> >
> > Hmm, do you really need notify at *every* swap free ?
> > No batching is necessary ?
> >
> 
> We need notify for every swap free and no batching is desired, at least for 
> compcache case.
> 
Okay..I'll read discussions in linux-mm.

Thanks you,
-Kame

