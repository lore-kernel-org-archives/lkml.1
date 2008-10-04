Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYJDXLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYJDXLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 19:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbYJDXK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 19:10:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:31475 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYJDXK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 19:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hMEOOKA8WsdR8PrUvkdY9TjmP2pN2KhI4D4SIOfZTyo9+6GzMLrGu/FwbRPL4VPXqz
         WGzADo2zsy5B2uyZipF0QkKS+Jlcv+fJFK96nS0TcwMaPJVZKaq+IX2q3ONk+zWTI7/3
         +QB/+Gw3CmwUrQ5ggICOHT34Z5zm4IPCtddMs=
Message-ID: <86802c440810041610r74cdde33ld14ae3e92f54ab4e@mail.gmail.com>
Date: Sat, 4 Oct 2008 16:10:57 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: Strange mtrrs in Aspire One
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081005010210.5a0835ff@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080930015733.5c6ea984@werewolf.home>
	 <86802c440809291805r71877ad1wc68525c1ca0603e1@mail.gmail.com>
	 <20081004152235.387a6f61@werewolf.home>
	 <86802c440810041055w17c42136l6884880acdb40e98@mail.gmail.com>
	 <86802c440810041454s500b66e8w165c0115a2284363@mail.gmail.com>
	 <20081005010210.5a0835ff@werewolf.home>
X-Google-Sender-Auth: ff623a3bfa85e1df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 4:02 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> On Sat, 4 Oct 2008 14:54:24 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:
>
>> On Sat, Oct 4, 2008 at 10:55 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Sat, Oct 4, 2008 at 6:22 AM, J.A. Magallón <jamagallon@ono.com> wrote:
>> >> On Mon, 29 Sep 2008 18:05:51 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:
>> >>
>> >>> On Mon, Sep 29, 2008 at 4:57 PM, J.A. Magallón <jamagallon@ono.com> wrote:
>> >>> > Hi all...
>> >>> >
>> >>> > My aspire one is giving some strange MTRR settings with rc7-git5 (and
>> >>> > prevous kernels, but that is what I run now...):
>> >>> >
>> >>> > one:~> cat /proc/mtrr
>> >>> > reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
>> >>> > reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
>> >>>
>> >>> could make mtrr_cleanup to support 128K gran_size
>> >>>
>> >>> > reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
>> >>> > reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
>> >>> > reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
>> >>> > reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
>> >>> > reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
>> >>>
>> >>> > reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
>> >>> ..
>> >>> >  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>> >>>
>> >>> last entry is really sick...
>> >>>
>> >>
>> >> I have applied the patches you have posted in other threads, and this
>> >> give a very strange result. The mtrr cleanup did nothing, and I had to put
>> >> some printk's all around.
>> >
>> > will have one patch to assume the [0, 1M) to be coverred by var mtrrs.
>> >
>>
>> please check other three patches.
>>
>> [PATCH 1/3] x86: mtrr_cleanup: print out correct type
>> [PATCH 2/3] x86: mtrr_cleanup: first 1M should be coverred in var mtrrs
>> [PATCH 3/3] x86: mtrr_cleanup: treat WRPROT as UNCACHEABLE
>>
>
> Thanks, will try.
>
>> you may need to boot with "mtrr_gran_size=64k mtrr_chunk_size=64k"
>>
>
> This makes me think about a question.
> In the dual xeon box, the 'cleanup' ends with this setup:
>
> werewolf:~> cat /proc/mtrr
> reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
> reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
> reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
> reg03: base=0x70000000 (1792MB), size= 128MB: write-back, count=1
> reg04: base=0x78000000 (1920MB), size=  64MB: write-back, count=1
> reg05: base=0x7c000000 (1984MB), size=  64MB: write-back, count=1
> reg06: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
>
> Ths options with 0 me loose were:
>
>  gran_size: 64K     chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
>  gran_size: 64K     chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
>  gran_size: 64K     chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
>  gran_size: 64K     chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
>  gran_size: 64K     chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
>  gran_size: 64K     chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
>  gran_size: 64K     chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
>  ...
>  gran_size: 128K    chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
>  gran_size: 128K    chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
>  gran_size: 128K    chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
>  gran_size: 128K    chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
>  gran_size: 128K    chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
>  gran_size: 128K    chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
>  gran_size: 128K    chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
>  ...
>  gran_size: 256K    chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
>  gran_size: 256K    chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
>  gran_size: 256K    chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
>  gran_size: 256K    chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
>  gran_size: 256K    chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
>  gran_size: 256K    chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
>  gran_size: 256K    chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
> ...
>  gran_size: 512K    chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
>  gran_size: 512K    chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
>  gran_size: 512K    chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
>  gran_size: 512K    chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
>  gran_size: 512K    chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
>  gran_size: 512K    chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
>  gran_size: 512K    chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
> ...
>  gran_size: 1M  chunk_size: 32M     num_reg: 8      lose cover RAM: 0G
>  gran_size: 1M  chunk_size: 64M     num_reg: 7      lose cover RAM: 0G
>  gran_size: 1M  chunk_size: 128M    num_reg: 6      lose cover RAM: 0G
>  gran_size: 1M  chunk_size: 256M    num_reg: 5      lose cover RAM: 0G
>  gran_size: 1M  chunk_size: 512M    num_reg: 4      lose cover RAM: 0G
>  gran_size: 1M  chunk_size: 1G  num_reg: 3      lose cover RAM: 0G
>  gran_size: 1M  chunk_size: 2G  num_reg: 2      lose cover RAM: 0G
>  ...
> Found optimal setting for mtrr clean up
> gran_size: 64K  chunk_size: 64M     num_reg: 7      lose RAM: 0G
>
> Why did it choose that using 7 registers ? Should'n it get that with the
> smallest number of used registers, and from those the bigger gran_size ?
> If the purpose is to leave space for more mtrrs (from X or other...).
> In short, what is the purpose of having this:
>
> reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
> reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
> reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
> reg03: base=0x70000000 (1792MB), size= 128MB: write-back, count=1
> reg04: base=0x78000000 (1920MB), size=  64MB: write-back, count=1
> reg05: base=0x7c000000 (1984MB), size=  64MB: write-back, count=1
> reg06: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
>
> instead of this:
>
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
>
> If both set a hole, not a set of valid zones without holes ?
>
> ??

please do check with tip/master.
http://people.redhat.com/mingo/tip.git/readme.txt

please boot with mtrr_cleanup_debug to find out right mtrr_gran_size
and mtrr_chunk_size...

YH
