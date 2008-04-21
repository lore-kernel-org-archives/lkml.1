Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbYDUPzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbYDUPzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYDUPyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:54:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57564 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYDUPyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:54:52 -0400
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Mitch Bradley <wmb@firmworks.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
In-Reply-To: <20080421102417.6de71391@ephemeral>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	 <20080419031024.GC3503@nineveh.local>
	 <20080418202925.b18452c5.akpm@linux-foundation.org>
	 <20080419092544.378664a8@ephemeral> <20080419133909.5aa6b63e@ephemeral>
	 <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	 <480C0582.9010509@firmworks.com>
	 <86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
	 <480C1286.3040307@firmworks.com>  <20080421102417.6de71391@ephemeral>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 16:54:13 +0100
Message-Id: <1208793253.9212.507.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 10:24 -0400, Andres Salomon wrote:
> I'm not actually convinced that we *do* want to keep OFW resident in memory,
> especially given the memory tricks we need to play.  I also don't actually
> like the OFW interface that we.  The debugging aspect of it was a
> compelling argument up until a week ago (when kernel debuggers started
> finally finding their way into the kernel).

I don't actually think that the debugging aspect was _ever_ a compelling
argument. It might have made it theoretically possible for _Mitch_ to
debug kernel problems, should he be inclined to do so -- but for the
rest of us mere mortals it's just a PITA trying to keep OpenFirmware
live. A gdb stub is much more useful, in my experience.

> However, until we clean up the promfs stuff, there's no chance of getting
> an OFW device tree upstream.

I see no reason why we shouldn't be able to create a 'flattened'
device-tree during early boot, like the PowerPC kernel does. And use it
thereafter, having quiesced OpenFirmware. Haven't we already been
working on unifying this between SPARC and PowerPC kernels?

I definitely don't think we need to play these tricks to keep
OpenFirmware resident while the kernel is running. Take a look at your
second patch -- it's _all_ just lookups in the device-tree, and you're
inventing a new way to do it instead of using the existing one.

-- 
dwmw2

