Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbYJFAkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbYJFAkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 20:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYJFAj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 20:39:59 -0400
Received: from smtp3.ono.com ([62.42.230.176]:22819 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751323AbYJFAj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 20:39:58 -0400
Date: Mon, 6 Oct 2008 02:39:52 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange mtrrs in Aspire One
Message-ID: <20081006023952.509e428a@werewolf.home>
In-Reply-To: <86802c440810041610r74cdde33ld14ae3e92f54ab4e@mail.gmail.com>
References: <20080930015733.5c6ea984@werewolf.home>
	<86802c440809291805r71877ad1wc68525c1ca0603e1@mail.gmail.com>
	<20081004152235.387a6f61@werewolf.home>
	<86802c440810041055w17c42136l6884880acdb40e98@mail.gmail.com>
	<86802c440810041454s500b66e8w165c0115a2284363@mail.gmail.com>
	<20081005010210.5a0835ff@werewolf.home>
	<86802c440810041610r74cdde33ld14ae3e92f54ab4e@mail.gmail.com>
X-Mailer: Claws Mail 3.6.0cvs2 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008 16:10:57 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:

> On Sat, Oct 4, 2008 at 4:02 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> > On Sat, 4 Oct 2008 14:54:24 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:
> >
> >> On Sat, Oct 4, 2008 at 10:55 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> > On Sat, Oct 4, 2008 at 6:22 AM, J.A. Magallón <jamagallon@ono.com> wrote:
> >> >> On Mon, 29 Sep 2008 18:05:51 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:
> >> >>
> >> >>> On Mon, Sep 29, 2008 at 4:57 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> >> >>> > Hi all...
> >> >>> >
> >> >>> > My aspire one is giving some strange MTRR settings with rc7-git5 (and
> >> >>> > prevous kernels, but that is what I run now...):
> >> >>> >
> >> >>> > one:~> cat /proc/mtrr
> >> >>> > reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
> >> >>> > reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
> >> >>>
> >> >>> could make mtrr_cleanup to support 128K gran_size
> >> >>>
> >> >>> > reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
> >> >>> > reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
> >> >>> > reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
> >> >>> > reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
> >> >>> > reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
> >> >>>
> >> >>> > reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
> >> >>> ..
> >> >>> >  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> >> >>>
> >> >>> last entry is really sick...
> >> >>>
> >> >>
> >> >> I have applied the patches you have posted in other threads, and this
> >> >> give a very strange result. The mtrr cleanup did nothing, and I had to put
> >> >> some printk's all around.
> >> >
> >> > will have one patch to assume the [0, 1M) to be coverred by var mtrrs.
> >> >
> >>
> >> please check other three patches.
> >>
> >> [PATCH 1/3] x86: mtrr_cleanup: print out correct type
> >> [PATCH 2/3] x86: mtrr_cleanup: first 1M should be coverred in var mtrrs
> >> [PATCH 3/3] x86: mtrr_cleanup: treat WRPROT as UNCACHEABLE
> >>
> >
> > Thanks, will try.
> >
> >> you may need to boot with "mtrr_gran_size=64k mtrr_chunk_size=64k"
> >>
> >
> > This makes me think about a question.
> > In the dual xeon box, the 'cleanup' ends with this setup:
> >
> > werewolf:~> cat /proc/mtrr
> > reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
> > reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
> > reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
> > reg03: base=0x70000000 (1792MB), size= 128MB: write-back, count=1
> > reg04: base=0x78000000 (1920MB), size=  64MB: write-back, count=1
> > reg05: base=0x7c000000 (1984MB), size=  64MB: write-back, count=1
> > reg06: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
> >
> > Ths options with 0 me loose were:
> >
> >  gran_size: 64K     chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
> >  gran_size: 64K     chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
> >  gran_size: 64K     chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
> >  gran_size: 64K     chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
> >  gran_size: 64K     chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
> >  gran_size: 64K     chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
> >  gran_size: 64K     chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
> >  ...
> >  gran_size: 128K    chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
> >  gran_size: 128K    chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
> >  gran_size: 128K    chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
> >  gran_size: 128K    chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
> >  gran_size: 128K    chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
> >  gran_size: 128K    chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
> >  gran_size: 128K    chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
> >  ...
> >  gran_size: 256K    chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
> >  gran_size: 256K    chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
> >  gran_size: 256K    chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
> >  gran_size: 256K    chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
> >  gran_size: 256K    chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
> >  gran_size: 256K    chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
> >  gran_size: 256K    chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
> > ...
> >  gran_size: 512K    chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
> >  gran_size: 512K    chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
> >  gran_size: 512K    chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
> >  gran_size: 512K    chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
> >  gran_size: 512K    chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
> >  gran_size: 512K    chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
> >  gran_size: 512K    chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
> > ...
> >  gran_size: 1M  chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
> >  gran_size: 1M  chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
> >  gran_size: 1M  chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
> >  gran_size: 1M  chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
> >  gran_size: 1M  chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
> >  gran_size: 1M  chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
> >  gran_size: 1M  chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
> >  ...
> > Found optimal setting for mtrr clean up
> > gran_size: 64K  chunk_size: 64M     num_reg: 7      lose RAM: 0G
> >
> > Why did it choose that using 7 registers ? Should'n it get that with the
> > smallest number of used registers, and from those the bigger gran_size ?
> > If the purpose is to leave space for more mtrrs (from X or other...).
> > In short, what is the purpose of having this:
> >
> > reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
> > reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
> > reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
> > reg03: base=0x70000000 (1792MB), size= 128MB: write-back, count=1
> > reg04: base=0x78000000 (1920MB), size=  64MB: write-back, count=1
> > reg05: base=0x7c000000 (1984MB), size=  64MB: write-back, count=1
> > reg06: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
> >
> > instead of this:
> >
> > reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> > reg01: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
> >
> > If both set a hole, not a set of valid zones without holes ?
> >
> > ??
> 
> please do check with tip/master.
> http://people.redhat.com/mingo/tip.git/readme.txt
> 
> please boot with mtrr_cleanup_debug to find out right mtrr_gran_size
> and mtrr_chunk_size...
> 

Kudos!!!

Finally I got messed with tip, and it all works.

For the Aspire One:

one:/proc> cat mtrr
reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
reg01: base=0x01f500000 (  501MB), size=    1MB, count=1: uncachable
reg02: base=0x01f600000 (  502MB), size=    2MB, count=1: uncachable
reg03: base=0x01f800000 (  504MB), size=    8MB, count=1: uncachable
reg04: base=0x020000000 (  512MB), size=  256MB, count=1: write-combining

(last one is set by x11 intel driver).

And for the dual Xeon:

werewolf:~> cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x07ff00000 ( 2047MB), size=    1MB, count=1: uncachable

So everything is fine.

Thanks !!

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
