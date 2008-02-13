Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbYBMASS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbYBMASS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYBMAR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:17:59 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:33139 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752322AbYBMAR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:17:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kHDKA+kitACxkDbAf8sUYllD22KXZA93DQi/jEzbFAQ79CYptBB/8ECl27go2S28pc0xmrlcafeWAnVAK/9Tb0y13NDd+tLzScJmewL55ln+g/aN9TzRd3AGbpg/WMoV19vX9F/tBWQ9FiUCRDaiF6k2/kBBnxJ4MJeC7y2RziE=  ;
X-YMail-OSG: yExIHU8VM1lc9VfCqJLR0ai.BrufZlVix8ex4heYMLxoJsqDw068KH5lo.MftQyCH3GP36ZtoA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.24-sha1: RIP  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Date: Wed, 13 Feb 2008 11:17:37 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080210140031.GA1754@martell.zuzino.mipt.ru> <20080212140430.c85e6018.akpm@linux-foundation.org> <20080212222704.GC2144@martell.zuzino.mipt.ru>
In-Reply-To: <20080212222704.GC2144@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131117.37389.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 09:27, Alexey Dobriyan wrote:
> On Tue, Feb 12, 2008 at 02:04:30PM -0800, Andrew Morton wrote:
> > On Sun, 10 Feb 2008 17:00:31 +0300
> >
> > Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > > This happened during LTP. FWIW, modprobe/rmmod trivial empty module
> > > together with cat /proc/*/wchan and cat /proc/modules were also
> > > running.
> > >
> > > Box is E6400, much debugging is on, config below.
> > >
> > >
> > > [ 4057.310000] BUG: unable to handle kernel paging request at
> > > ffff810101dbc008 [ 4057.310000] IP: [<ffffffff802596c8>]
> > > iov_iter_advance+0x38/0x70 [ 4057.310000] PGD 8063 PUD c063 PMD
> > > 153baa163 PTE 8000000101dbc160 [ 4057.310000] Oops: 0000 [1] SMP
> > > DEBUG_PAGEALLOC
> > > [ 4057.310000] CPU 0
> > > [ 4057.310000] Modules linked in: [last unloaded: foo]
> >
> > what is this foo.ko of which you speak, and did it wreck your kernel?
>
> It's a trivial dumb module which does nothing but loads and unloads.
> I redid ftest03 later without any suspicious activity and it oopsed the
> same way.

Ah crap. Hmm, maybe I didn't consider all cases with my last patch to
that code... is there an easy way to get the ftest03 source and run
it?
