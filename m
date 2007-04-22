Return-Path: <linux-kernel-owner+w=401wt.eu-S1030907AbXDVO2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030907AbXDVO2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030910AbXDVO2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:28:12 -0400
Received: from 1wt.eu ([62.212.114.60]:2205 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030907AbXDVO2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:28:10 -0400
Date: Sun, 22 Apr 2007 16:22:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Michael Gerdau <mgd@technosis.de>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Al Boldi <a1426z@gawab.com>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [ck] Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Message-ID: <20070422142216.GA17210@1wt.eu>
References: <200704221441.48897.kernel@kolivas.org> <20070422091451.GA15913@1wt.eu> <200704222142.52325.kernel@kolivas.org> <200704222218.32754.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704222218.32754.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 10:18:32PM +1000, Con Kolivas wrote:
> On Sunday 22 April 2007 21:42, Con Kolivas wrote:
> 
> Willy I'm still investigating the idle time and fluctuating load as a separate 
> issue. Is it possible the multiple ocbench processes are naturally 
> synchronising and desynchronising and choosing to sleep and/or run at the 
> same time? I can remove the idle time entirely by running ocbench at nice 19 
> which means they are all forced to run at basically the same time by the 
> scheduler.
> 
> Anyway the more important part is... Can you test this patch please? Dump
> all the other patches I sent you post 045. Michael, if you could test too
> please?

OK, it's better now. All tasks equally run. X is still somewhat jerky, even
at nice -19. I'm sure it happens when it's waiting in the other array. We
should definitely manage to get rid of this if we want to ensure low latency.

Just FYI, the idle is often close to zero and the load is often close to 30,
even if still fluctuating :

   procs                      memory      swap          io     system      cpu
 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
22  0  0      0 922876   6472  57848    0    0     0     0  164  3275 34 58  8
14  0  0      0 922648   6472  57864    0    0     0     0    8   383 37 63  0
24  0  0      0 922580   6472  57864    0    0     0   128   32   219 34 66  0
13  0  1      0 922524   6472  57864    0    0     0     0    0   393 35 64  0
31  0  0      0 922524   6472  57864    0    0     0     0    3   338 37 63  0
56  0  0      0 922556   6472  57864    0    0     0     0    0   290 35 65  0
57  0  1      0 922556   6472  57864    0    0     0     0    1   288 33 55 11
45  0  0      0 922556   6472  57864    0    0     0     0    1   255 27 52 21
38  0  0      0 922564   6472  57864    0    0     0     0    0   161 24 49 27
 0  0  0      0 922564   6472  57864    0    0     0     0    1   142 23 40 38
 0  0  0      0 922564   6472  57864    0    0     0     0    2   182 29 55 16
22  0  0      0 922564   6472  57864    0    0     0     0    1   253 28 48 24
26  0  0      0 922564   6472  57864    0    0     0     0    1   212 31 60  9
27  0  0      0 922564   6472  57864    0    0     0     0    1   314 31 70  0
44  0  0      0 922564   6472  57864    0    0     0     0    2   282 32 62  6
54  0  1      0 922564   6472  57864    0    0     0     0   26   213 32 67  1
42  0  0      0 922564   6472  57864    0    0     0     0  142   278 34 61  4
35  0  0      0 922564   6472  57864    0    0     0     0   58   226 39 61  0
 6  0  0      0 922564   6472  57864    0    0     0     0   79   228 35 65  0
 5  0  0      0 922564   6472  57864    0    0     0     0   98   225 36 61  3
35  0  1      0 922564   6472  57864    0    0     0     0   71   205 22 41 36

Hoping this helps !
Willy

