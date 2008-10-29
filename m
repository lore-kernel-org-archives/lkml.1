Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbYJ2KAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbYJ2KAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYJ2J7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:59:55 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:35593 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753070AbYJ2J7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:59:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rrRkIduNYlb1wbiI4hh6nRbewiTIBXsVPvVkIzmrxn0AzmyKsUxU3gu2zAMvDyj50EAqMYO9F/bGpPEhZjfU2P9we3d0pcalPRGKIr1CMOlOb5POHaukFKLqDRxlj1SjFmgLQMnH9JeFUtfRZvyCgSK3RDxGT7lmJqOjw2ATOdw=  ;
X-YMail-OSG: eg_uEm8VM1nMhgtXHciNaaAIuEPMbdbGsn5CJzoknmAloHyMyFcR6vhPe9YnYUYdr18MQy_NHlvoUmNzF6sWl4CvQRXg3wMqIEWFim4myIDAcaUgkRWt129qjXq6B2ArBBT12rBdJSS_NT3YAaaNagkx4Hetb5sgjcVAYCFvagCDtW.jyMiM4nRkww0N
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Date: Wed, 29 Oct 2008 20:59:37 +1100
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl, s0mbre@tservice.net.ru,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <1224917623.4929.15.camel@marge.simson.net> <20081027113306.5b1d5898@lxorguk.ukuu.org.uk> <20081027183312.GD11494@elte.hu>
In-Reply-To: <20081027183312.GD11494@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810292059.37995.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008 05:33, Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > The way to get the best possible dbench numbers in CPU-bound dbench
> > > runs, you have to throw away the scheduler completely, and do this
> > > instead:
> > >
> > >  - first execute all requests of client 1
> > >  - then execute all requests of client 2
> > >  ....
> > >  - execute all requests of client N
> >
> > Rubbish. [...]
>
> i've actually implemented that about a decade ago: i've tracked down
> what makes dbench tick, i've implemented the kernel heuristics for it
> to make dbench scale linearly with the number of clients - just to be
> shot down by Linus about my utter rubbish approach ;-)
>
> > [...] If you do that you'll not get enough I/O in parallel to
> > schedule the disk well (not that most of our I/O schedulers are
> > doing the job well, and the vm writeback threads then mess it up and
> > the lack of Arjans ioprio fixes then totally screw you) </rant>
>
> the best dbench results come from systems that have enough RAM to
> cache the full working set, and a filesystem intelligent enough to not
> insert bogus IO serialization cycles (ext3 is not such a filesystem).

You can get good dbench results come from dbench on tmpfs, which
exercises the vm vfs scheduler etc without IO or filesystems.
