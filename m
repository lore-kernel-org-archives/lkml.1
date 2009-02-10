Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZBJQ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZBJQ2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 11:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZBJQ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 11:28:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60917 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbZBJQ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 11:28:19 -0500
Subject: Re: [PATCH] wireless: introduce POWEROF2_BLOCKSIZE_ONLY option
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bryan Wu <cooloney@kernel.org>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>
In-Reply-To: <20090210160451.GD3534@tuxdriver.com>
References: <1233819002-6912-1-git-send-email-cooloney@kernel.org>
	 <1233846195.3028.14.camel@localhost>
	 <386072610902052347m5754262bif18339809a00cb9f@mail.gmail.com>
	 <386072610902060000s2e150e4cla19aca70f38b0474@mail.gmail.com>
	 <20090210160451.GD3534@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 11:26:45 -0500
Message-Id: <1234283205.3119.64.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 11:04 -0500, John W. Linville wrote:
> On Fri, Feb 06, 2009 at 04:00:28PM +0800, Bryan Wu wrote:
> > On Fri, Feb 6, 2009 at 3:47 PM, Bryan Wu <cooloney@kernel.org> wrote:
> > > On Thu, Feb 5, 2009 at 11:03 PM, Dan Williams <dcbw@redhat.com> wrote:
> > >> On Thu, 2009-02-05 at 15:30 +0800, Bryan Wu wrote:
> > >>> From: Cliff Cai <cliff.cai@analog.com>
> > >>>
> > >>> Introduce POWEROF2_BLOCKSIZE_ONLY option for those SD/SDIO host
> > >>> which only support transferring block with size of power-of-2
> > >>
> > >> Is the point here to avoid copying in the controller code?  As with the
> > >> other patches on libertas-dev, I really dislike adding code to *every
> > >> SDIO driver* just because the host has certain restrictions.  I'd much
> > >> rather that the host/controller code became aware of it's own
> > >> restrictions, and exposed those generically to drivers above it.
> > >> Without a KConfig option.
> > >>
> > >> Seriously.  The host knows what it needs.  The code to handle that
> > >> should go in the host.
> > >>
> > >
> > > I agree here.
> > >
> > >> How about adding a method like "sdio_align_size" that takes the
> > >> controller's constraints into account?  That seems a lot cleaner than
> > >> adding #define/KConfig junk to every SDIO driver in the kernel.  One
> > >> less codepath to test, makes your life and all our lives easier.
> > >>
> > >
> > > So we plan to add method ".sdio_align_size" to SDIO stack.
> > > And Blackfin host driver will implement this method while others will
> > > implement this as a dummy function.
> > >
> > 
> > sdio_align_size is already in SDIO stack, so we just need to add our
> > constraints to this function.
> 
> I'm reading this as "this patch is unnecessary or will be replaced
> by something better", so I'm dropping it.  If I misread that, feel
> free to repost...thanks!

Yeah, some patches got posted to the MMC lists that do what this patch
would do, but do it in a somewhat better manner.

Dan


