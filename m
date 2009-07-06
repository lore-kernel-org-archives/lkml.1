Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZGFUCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZGFUCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZGFUCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:02:00 -0400
Received: from smtp.df.ru ([195.42.160.16]:38019 "EHLO smtp.df.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbZGFUCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:02:00 -0400
Date: Tue, 7 Jul 2009 00:03:11 +0400
From: Alexey Vlasov <renton@renton.name>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: devpts mounts too slowly
Message-ID: <20090706200311.GB7484@beaver.vrungel.ru>
References: <20090603142801.GC21646@beaver.vrungel.ru> <4A26EB18.6060907@zytor.com> <20090609161945.811cc01f.akpm@linux-foundation.org> <2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com> <4A2EF833.6080300@zytor.com> <20090706195252.GA7484@beaver.vrungel.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20090706195252.GA7484@beaver.vrungel.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 11:52:52PM +0400, Alexey Vlasov wrote:
> On Tue, Jun 09, 2009 at 05:02:59PM -0700, H. Peter Anvin wrote:
> 
> > A quick script seems to confirm that the time starts creeping up as the
> > number of mount points increase; on my Core i7 system the 10000th mount
> > takes around 50 ms whereas the early instances are submillisecond, and
> > the increase *seems* to be O(n log n) or thereabouts -- slightly
> > superlinear but not a good fit for a power law.
> 
> I have prepared a new machine for testing, and I don't see any slowdown
> by mounting devpts.
> Total mounts on it:
> # wc -l /proc/mounts
> 153481 /proc/mounts
> # fgrep -c devpts /proc/mounts
> 10231
> 
> On my other servers there're slowdown already by this number of:
> # wc -l /proc/mounts
> 49889 /proc/mounts
> # fgrep -c devpts /proc/mounts
> 3323

One more notice, box with slowdowns:
...
geteuid()                               = 0
getcwd("/home/staff/r_renton"..., 4095) = 21
readlink("/home/staff/r_renton/none", 0x7ffffa32aa00, 4096) = -1 ENOENT
(No such file or directory)
rt_sigprocmask(SIG_BLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
mount("none", "/home/www/server_7e014b11/dev/pts",
"devpts", MS_MGC_VAL, NULL) = 0
getcwd("/home/staff/r_renton"..., 4095) = 21
...

And this on the new one, about 100k mounting points and no
slowdowns at all.
...
getuid()                                = 0
geteuid()                               = 0
rt_sigprocmask(SIG_BLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
mount("none", "/home/www/server_56d48c7d/dev/pts", "devpts",
MS_MGC_VAL, NULL) = 0
readlink("/home", 0x7fff79a82e10, 4096) = -1 EINVAL (Invalid argument)
...

-- 
BRGDS. Alexey Vlasov.
