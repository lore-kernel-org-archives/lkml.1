Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYJBXAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYJBXAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYJBXAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:00:05 -0400
Received: from smtp3.ono.com ([62.42.230.176]:26347 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753722AbYJBXAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:00:04 -0400
Date: Fri, 3 Oct 2008 01:00:00 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Message-ID: <20081003010000.731eb2b3@werewolf.home>
In-Reply-To: <86802c440810021552q1959d4bh348d557430f263d2@mail.gmail.com>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
	<1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
	<20081003000314.771b2f68@werewolf.home>
	<86802c440810021533v572975e8n40e55009cc2b2d8a@mail.gmail.com>
	<86802c440810021552q1959d4bh348d557430f263d2@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0cvs144 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 15:52:11 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:

> On Thu, Oct 2, 2008 at 3:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Thu, Oct 2, 2008 at 3:03 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> >> On Mon, 29 Sep 2008 18:54:12 -0700, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >>
> >>>
> >>> so start from 64k instead of 1M
> >>>
> >>
> >> Or there is something I don't catch about mtrrs, or it still does silly
> >> things.
> >>
> >> I have an ASUS PCDL, dual xeon, 2Gb of memory. Mtrrs after cleanup are:
> >>
> >> werewolf:/proc> cat mtrr
> >> reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
> >> reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
> >> reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
> >> reg03: base=0x70000000 (1792MB), size= 128MB: write-back, count=1
> >> reg04: base=0x78000000 (1920MB), size=  64MB: write-back, count=1
> >> reg05: base=0x7c000000 (1984MB), size=  64MB: write-back, count=1
> >> reg06: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
> >>
> >> So it adds a last WB zone, but substracts the last 1Mb. (Why do
> >> I have that stupid uncacheable mb ? probably a bios issue...)
> >> But those two 64 mb zones could be add to a 128Mb, that new one
> >> with previous to 256Mb and so on, giving something like:
> >>
> >> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> >> reg01: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
> >>
> >> Is this incorrect ?
> >>
> >
> > can you boot with mtrr_cleanup_debug?
> >
> > also what is /proc/mtrr with disable_mtrr_cleanup?
> 
> are you on latest tip/master?
> 

No, I use rc8-git3 with your patches (the small gran_size series and the
parameter rename, except the debug one) manually applied.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
