Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbZCaHou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbZCaHou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbZCaHoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:44:39 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37325 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZCaHoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=HBpui46s/HPhUdioWNfVE6YyfVDE1m2Qm2hzWnv74PI00aM7k2SXnCcDkHGKKeFYYI
         CKwNp7+ejaEyAqD2ZP01QN0j5hABTXGsrqKte7S8jkyq9mPOA3taihdy6LElo/X5fcu6
         y9lHkMLpQGooyrowPfYmlf5FDRUhKgGLivSsg=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.29 git master and PAT problems
Date: Tue, 31 Mar 2009 09:44:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200903310125.12120.a.miskiewicz@gmail.com> <20090331002100.GA10490@linux-os.sc.intel.com>
In-Reply-To: <20090331002100.GA10490@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903310944.32883.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 of March 2009, Pallipadi, Venkatesh wrote:
> On Mon, Mar 30, 2009 at 04:25:11PM -0700, Arkadiusz Miskiewicz wrote:
> > On Tuesday 31 of March 2009, Arkadiusz Miskiewicz wrote:
> > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > >
> > > More info follows. Now I've switched to
> > > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm
> > > fixes and now I get much lower numbers of PAT errors but still.
> >
> > Also when I switch t400 into discrete mode (radeon hd 3400 instead
> > of integrated intel GM45) I get such errors (probably unrelated
> > to these seen when using intel):
> >
> > [  419.187657] X:10550 conflicting memory types cfff0000-d0000000
> > uncached<->uncached-minus [  419.187670] reserve_memtype failed
> > 0xcfff0000-0xd0000000, track uncached, req write-back [  419.553914]
> > X:10550 conflicting memory types cfff0000-d0000000
> > uncached<->uncached-minus [  419.553923] reserve_memtype failed
> > 0xcfff0000-0xd0000000, track uncached, req write-back [  419.813592]
> > X:10550 conflicting memory types cfff0000-d0000000
> > uncached<->uncached-minus [  419.813601] reserve_memtype failed
> > 0xcfff0000-0xd0000000, track uncached, req write-back [  420.100102]
> > X:10550 conflicting memory types cfff0000-d0000000
> > uncached<->uncached-minus [  420.100111] reserve_memtype failed
> > 0xcfff0000-0xd0000000, track uncached, req write-back
>
> Yes. This is a different problem than the freeing invalid type one. Are
> these errors also with latest git kernel? Can you try the patch below
> (which is a part of a bigger cleanup patch I have lined up).

It's a latest git kernel as of today morning
(latest commit is 15f7176eb1cccec0a332541285ee752b935c1c85)
+ your patch. Problem persists:

[   74.696353] [drm] Setting GART location based on new memory map
[   74.711520] [drm] Loading RV620 CP Microcode
[   74.711792] [drm] Loading RV620 PFP Microcode
[   74.726719] [drm] Resetting GPU
[   74.726776] [drm] writeback test succeeded in 1 usecs
[   75.256034] X:5366 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
[   75.256043] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
[   75.849951] X:5366 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
[   75.849960] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
[   76.054374] X:5366 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
[   76.054377] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
[   76.074481] X:5378 freeing invalid memtype d0000000-e0000000
[   76.176881] X:5366 conflicting memory types d0000000-e0000000 uncached-minus<->write-combining
[   76.176885] reserve_memtype failed 0xd0000000-0xe0000000, track uncached-minus, req write-back
[   76.207734] X:5380 freeing invalid memtype d0000000-e0000000

cat /debug/x86/pat_memtype_list
PAT memtype list:
uncached-minus @ 0xbfad1000-0xbfad2000
uncached-minus @ 0xbfad2000-0xbfad3000
uncached-minus @ 0xbfad3000-0xbfad4000
uncached-minus @ 0xbfb06000-0xbfb07000
uncached-minus @ 0xbfb07000-0xbfb08000
uncached-minus @ 0xbfd6a000-0xbfd6b000
uncached-minus @ 0xbfd6a000-0xbfd6b000
uncached-minus @ 0xbfd6a000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd79000-0xbfd7a000
uncached-minus @ 0xbfd7b000-0xbfd7c000
uncached-minus @ 0xbfd8d000-0xbfd8e000
uncached-minus @ 0xbfd8e000-0xbfd8f000
uncached-minus @ 0xbfd8e000-0xbfd8f000
uncached-minus @ 0xcfff0000-0xd0000000
uncached-minus @ 0xcfff0000-0xd0000000
uncached-minus @ 0xcfff0000-0xd0000000
uncached-minus @ 0xcfff0000-0xd0000000
uncached-minus @ 0xcfff0000-0xd0000000
write-combining @ 0xdfff0000-0xe0000000
uncached-minus @ 0xe0000000-0xe4000000
uncached-minus @ 0xf4200000-0xf4202000
uncached-minus @ 0xf4300000-0xf4301000
uncached-minus @ 0xf4301000-0xf4302000
uncached-minus @ 0xf4301000-0xf4302000
uncached-minus @ 0xfc200000-0xfc220000
uncached-minus @ 0xfc220000-0xfc224000
uncached-minus @ 0xfc225000-0xfc226000
uncached-minus @ 0xfc226000-0xfc227000
uncached-minus @ 0xfc226000-0xfc227000
uncached-minus @ 0xfc227000-0xfc228000
uncached-minus @ 0xfed00000-0xfed01000
uncached-minus @ 0xfed1f000-0xfed20000
cat /proc/mtrr
reg00: base=0x13c000000 ( 5056MB), size=   64MB, count=1: uncachable
reg01: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg02: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg03: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
reg04: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining

>
> Thanks,
> Venki
>
> From: Suresh Siddha <suresh.b.siddha@intel.com>
>
> Fix pat_x_mtrr_type() to use UC_MINUS when the mtrr type return UC. This
> is to be  consistent with ioremap() and ioremap_nocache() which uses
> UC_MINUS.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  arch/x86/mm/ioremap.c |    3 ++-
>  arch/x86/mm/pat.c     |   35 +++++++++++++----------------------
>  2 files changed, 15 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 1fca82b..e07da24 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -182,10 +182,10 @@ static unsigned long pat_x_mtrr_type(u64 start, u64
> end, unsigned long req_type) u8 mtrr_type;
>
>  		mtrr_type = mtrr_type_lookup(start, end);
> -		if (mtrr_type == MTRR_TYPE_UNCACHABLE)
> -			return _PAGE_CACHE_UC;
> -		if (mtrr_type == MTRR_TYPE_WRCOMB)
> -			return _PAGE_CACHE_WC;
> +		if (mtrr_type != MTRR_TYPE_WRBACK)
> +			return _PAGE_CACHE_UC_MINUS;
> +
> +		return _PAGE_CACHE_WB;
>  	}
>
>  	return req_type;


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

