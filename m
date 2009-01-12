Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZALIYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZALIYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZALIXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:23:55 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:54450 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750770AbZALIXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:23:54 -0500
Date: Mon, 12 Jan 2009 17:20:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Mark A. Miller" <mark@mirell.org>
Cc: Bernd Petrovitsch <bernd@firmix.at>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090112082058.GB28564@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Mark A. Miller" <mark@mirell.org>,
	Bernd Petrovitsch <bernd@firmix.at>,
	Leon Woestenberg <leon.woestenberg@gmail.com>,
	Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
	Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com> <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net> <20090104030619.GA21466@linux-sh.org> <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com> <1231677939.3517.5.camel@gimli.at.home> <31014a580901111936q41486efagcb90af2b6880a470@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31014a580901111936q41486efagcb90af2b6880a470@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 09:36:58PM -0600, Mark A. Miller wrote:
> Actually, something that has amused me during this discussion, is that
> right now, the latest stable Perl (5.8.8) does not compile correctly
> on a uclibc host, which is typically what you want for embedded
> systems, which is why you'd bother to cross compile. (Albeit I was
> doing this natively under QEMU with a gcc/uclibc toolchain).
> 
> I'll have a patch submitted upstream shortly, but basically the
> hints/linux.sh assumes *obviously* you're linking to glibc. I've made
> that less libc dependent, looking for either glibc or uclibc.
> 
There are plenty that ship with glibc, too. What you "want" for embedded
systems depends entirely on the application for the device, not general
hand-wavy assertions. We (Renesas) ship BSPs on both precisely because of
this reason, and eglibc will probably factor in at some point later on
too.

> So without patching Perl, by adding it to the kernel configuration,
> it's broken being able to compile the kernel on most embedded
> architectures.
> 
This again has nothing to do with the kernel and everything to do with
your distribution. I use perl on uclibc natively just fine, it is
possible there are patches that have not been merged upstream, but this
is again an entirely separate issue.

You seem to be confusing the fact that people who build distributions and
people who use them are one and the same, whereas "most" embedded
developers are going to be using pre-built distributions provided with
their reference hardware, and locking it down during productization. The
fact you are doing a distribution aimed at embedded devices is nice, but
do not try to push off problems you run in to that have a reasonable
expectation of working everywhere else on to the kernel community as
something we ought to care about. 

If you need to use a different libc on your platform, yes, you will have
to update packages for this. This used to be true for gcc and other
packages as well, but those were all fixed over time. The fact perl still
stands out despite there being patches available is simply an indicator
that folks working in that area haven't been very proactive in getting
their changes merged upstream. Tough.

This is now entirely off-topic and has nothing to do with the kernel any
more. Please take this to the uclibc or perl lists instead.
