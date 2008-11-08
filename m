Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbYKHCyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbYKHCyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 21:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYKHCy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 21:54:28 -0500
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:39794 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751741AbYKHCy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 21:54:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=odOnXLpeJPYRIl3VBNH8DzbKI2BMl6Ryy6UsU7yZr319LMsNs2emEgsXbDJRsEHv/4Xs0xWjxPQkN0rmfQasq4RpbhJ8kTZPU05xo7FRnTwLSVFkvswXDLHarvJ/6Fwjym3k1VtPhZsA147tI6sf+9ULtEutOppS5V1UV1NfDjk=  ;
X-YMail-OSG: 0N1e3zwVM1mftGvGOW9iYXWXEXI3nJVlMhvYRGOjRxystIGVKDqiOuthzBPQbcBDVqBiyYx21cltdqoOg_MwdahQ3yV7kJ8rFzja0Y.fZTL0aCxrkqyIo_NwnxxpL8WOjXCyQh5iIeDex6ECcVwm650XxZE0uoHm3sHtmf3E
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCH 0/4] Fix vmalloc regression
Date: Sat, 8 Nov 2008 13:54:14 +1100
User-Agent: KMail/1.9.5
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, avi@redhat.com
References: <1226097354-7523-1-git-send-email-glommer@redhat.com> <20081108005832.GA2068@wotan.suse.de> <20081108021315.GB21674@poweredge.glommer>
In-Reply-To: <20081108021315.GB21674@poweredge.glommer>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811081354.15076.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 November 2008 13:13, Glauber Costa wrote:
> On Sat, Nov 08, 2008 at 01:58:32AM +0100, Nick Piggin wrote:
> > On Fri, Nov 07, 2008 at 08:35:50PM -0200, Glauber Costa wrote:
> > > Nick,
> > >
> > > This is the whole set of patches I was talking about.
> > > Patch 3 is the one that in fact fixes the problem
> > > Patches 1 and 2 are debugging aids I made use of, and could be possibly
> > > useful to others
> > > Patch 4 removes guard pages entirely for non-debug kernels, as we have
> > > already previously discussed.
> > >
> > > Hope it's all fine.
> >
> > OK, these all look good, but I may only push 3/4 for Linus in this round,
> > along with some of the changes from my patch that you tested as well.
>
> Makes total sense.

OK, sent. Thanks again.


> > With the DEBUG_PAGEALLOC case, I have been thinking that we perhaps
> > should turn off the lazy unmapping optimisation as well, so it catches
> > use after free similarly to the page allocator... but probably it is a
> > good idea at least to avoid the double-guard page for 2.6.28?
>
> Makes sense. Maybe poisoning after free would also be useful?

It's a problem because we're only dealing with virtual address, rather
than real memory. So we don't really have anything to poison (we don't
know what the caller will do with the memory). I guess it would be
possible to poison in the page allocator or in vfree, but.... probably
not worthwhile (after the immediate-unmap debug option).
