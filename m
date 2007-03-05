Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXCEHfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXCEHfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbXCEHfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:35:16 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:34741 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbXCEHfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:35:13 -0500
X-IronPort-AV: i="4.14,247,1170651600"; 
   d="scan'208"; a="29931456:sNHT91926254"
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703032330.50116.arnd@arndb.de>
References: <1172722480.5264.75.camel@roc-desktop>
	 <200703032330.50116.arnd@arndb.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 05 Mar 2007 15:34:51 +0800
Message-Id: <1173080091.5264.178.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-03 at 17:30 -0500, Arnd Bergmann wrote:
> On Thursday 01 March 2007 05:14:40 Wu, Bryan wrote:
> > Here is the update version of blackfin-arch.patch in -mm tree.
> > simply add support to utrace and it was tested on blackfin STAMP
> board
> > as well as other following patches.
> 
> Wow, this has come a long way since I looked at the patches last
> year, good work!

Yeah, old friend comes back. Thanks a lot for your review.
We fixed lots of things according to your review since last year.
> 
> I've gone through the complete patch again now, and these are the
> issues I've found in it. None of these are show-stoppers and I'd
> like to see it all go in during the next merge window. There should
> be enough time until then to address these points:

Lots of valuable comments got from you, we will get things done soon.
So could please give us some information about the merge window
schedule, we may try to catch this.

>  +
> > +/* Clock and System Control (0xFFC0 0400-0xFFC0 07FF) */
> > +#define bfin_read_PLL_CTL()                  bfin_read16(PLL_CTL)
> > +#define bfin_write_PLL_CTL(val)
> bfin_write16(PLL_CTL,val)
> > +#define bfin_read_PLL_STAT()                 bfin_read16(PLL_STAT)
> > +#define bfin_write_PLL_STAT(val)
> bfin_write16(PLL_STAT,val)
> > +#define bfin_read_PLL_LOCKCNT()
> bfin_read16(PLL_LOCKCNT)
> > +#define bfin_write_PLL_LOCKCNT(val)
> bfin_write16(PLL_LOCKCNT,val)
> > +#define bfin_read_CHIPID()                   bfin_read32(CHIPID)
> > +#define bfin_read_SWRST()                    bfin_read16(SWRST)
> > +#define bfin_write_SWRST(val)
> bfin_write16(SWRST,val)
> 
> I remember that we have discussed these macro abstractions before, but
> don't
> recall the result of the discussion. You have around 5000 such macros,
> and I still think it's not a helpful abstraction. It is much more
> common
> for device drivers to just use the read/write accessors directly. IIRC
> the objections that were raised (and my replies to them) were roughly:
> 
> > the driver writer doesn't want to know the size of the variable, and
> > if it changes, they need to change every instance in the code, not
> > just the macro.
> 
> A driver writer should better know the type of variable he is
> changing,
> e.g. because of the type he passes in and out. Also, hardware
> registers
> don't suddenly change in size.
> 
> > These macros allow us to work around hardware bugs when accessing
> the
> > registers by simply redefining the accessor to do something more
> > complex.
> 
> If there is a bug in the hardware, the workaround belongs into the
> driver. You can then still define a special inline function to
> access that particular register.
> 
Oh, if we should fix this issue, there are lots of work to do because
tons of drivers rely on this. Maybe after some team internal discussion,
we will give a solution to this.

Thanks again
Best Regards,
-Bryan Wu

