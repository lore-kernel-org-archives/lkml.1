Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYEJGTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYEJGTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 02:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYEJGTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 02:19:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:9192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYEJGTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 02:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PkrujFt3IyDUQnH3Xupmvxv/BegyKsvN7YeyLPm7DnrVLVNQ0XLZ025X/d0UqY3kzNS56deanrXD7p5TddttkmhxJ01x09Ho6hbMApC/MEgRbVuY/s6kXjg0YaqwbYPfpQgpHqlS8ejuAw0SDy/ayTwnau7uqS5WUz61MNUoO00=
Message-ID: <21d7e9970805092319n1d31be36h2f2c7d46622f46c8@mail.gmail.com>
Date: Sat, 10 May 2008 16:19:27 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [git head] X86_PAT & mprotect
Cc: "Ingo Molnar" <mingo@elte.hu>, "Hugh Dickins" <hugh@veritas.com>,
       "Frans Pop" <elendil@planet.nl>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Nick Piggin" <npiggin@suse.de>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE010471B6@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805022122.03576.elendil@planet.nl>
	 <200805051932.41827.elendil@planet.nl>
	 <20080506224240.GA18706@linux-os.sc.intel.com>
	 <20080507070217.GD32195@elte.hu>
	 <Pine.LNX.4.64.0805071941140.18916@blonde.site>
	 <20080507232326.GB10757@linux-os.sc.intel.com>
	 <20080509100818.GD19617@elte.hu>
	 <20080509200519.GA10897@linux-os.sc.intel.com>
	 <21d7e9970805091511n2c6b6cfeu433b184d3031196d@mail.gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEE010471B6@orsmsx423.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 8:20 AM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:
>
>
>
>  >-----Original Message-----
>  >From: Dave Airlie [mailto:airlied@gmail.com]
>  >Sent: Friday, May 09, 2008 3:11 PM
>  >To: Pallipadi, Venkatesh
>  >Cc: Ingo Molnar; Hugh Dickins; Frans Pop; Barnes, Jesse;
>  >linux-kernel@vger.kernel.org; Packard, Keith; Yinghai Lu;
>  >Andrew Morton; Linus Torvalds; H. Peter Anvin; Thomas
>  >Gleixner; Nick Piggin; Jesse Barnes
>  >Subject: Re: [git head] X86_PAT & mprotect
>  >
>  >On Sat, May 10, 2008 at 6:05 AM, Venki Pallipadi
>  ><venkatesh.pallipadi@intel.com> wrote:
>  >> On Fri, May 09, 2008 at 12:08:18PM +0200, Ingo Molnar wrote:
>  >>  >
>  >>  > * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>  >>  >
>  >>  > > > I've tried doing it slightly differently below, don't
>  >know whether
>  >>  > > > you'll consider it an improvement or not.
>  >>  > >
>  >>  > > Hugh: Thanks for looking into this. Yes. I like your
>  >modified patch.
>  >>  > > Simpler and smaller.
>  >>  >
>  >>  > i have stuck your original patch into testing and nothing
>  >blew up so
>  >>  > far. Due to the mm/ bits this is not for the scope of x86.git, but
>  >>  > obviously it all looks good and is .26-worthy to me:
>  >>  >
>  >>  >  Acked-by: Ingo Molnar <mingo@elte.hu>
>  >>  >  Tested-by: Ingo Molnar <mingo@elte.hu>
>  >>  >
>  >>  > Venki, could you please send a full patch against -git that has
>  >>  > everything from Hugh included, with an updated changelog, for
>  >>  > Linus/Andrew to ack/apply?
>  >>  >
>  >>
>  >>  Ingo,
>  >>
>  >>  Split up the patch into two parts as the pci part was
>  >unrelated to mprotect
>  >>  problem in a sense.
>  >>
>  >>  Here is the first patch.
>  >>
>  >>  Thanks,
>  >>  Venki
>  >>
>  >>
>  >>  Some versions of X used the mprotect workaround to change
>  >caching type from
>  >>
>  >> UC to WB, so that it can then use mtrr to program WC for
>  >that region [1].
>  >>  Change the mmap of pci space through /sys or /proc
>  >interfaces from UC to
>  >>  UC_MINUS. With this change, X will not need to use mprotect
>  >>  workaround to get WC type.
>  >>  Also the bug with mprotect which lets caller to change PAT
>  >bits is fixed in
>  >>  the follow on patch. So, this X workaround will stop
>  >working as well.
>  >>
>  >
>  >Wow this kinda puts X in a nasty position, we have 2.6.25 and
>  >previous kernels
>  >where we use the original /sys interfaces and nasty hack to
>  >workaround, but on 2.6.26 we magically need to
>  >switch to the /sys _uc interfaces or the users X will slow down.
>  >
>
>  No. With 2.6.26 you can still use same /sys resource file, without
>  the mprotect workaround and set the MTRR as before.
>
>  The change from UC to UC_MINUS in this patch ensures that the
>  X drivers MTRR will take precedence and X does not need any mprotect
>  hacks.
>

Cool just making sure.

Keithp, I hope we didn't error check the mremap return values :)

Dave.
