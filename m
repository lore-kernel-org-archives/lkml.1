Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYBEQNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYBEQNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYBEQMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:12:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35642 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751466AbYBEQMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:12:51 -0500
Date: Tue, 5 Feb 2008 17:12:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [regression] Re: brk randomization breaks columns
Message-ID: <20080205161246.GE24331@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <20080205110632.GB3758@elf.ucw.cz> <Pine.LNX.4.64.0802051216340.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802051216340.30955@jikos.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-05 13:50:51, Jiri Kosina wrote:
> On Tue, 5 Feb 2008, Pavel Machek wrote:
> 
> > > Actually, this clearly shows that either prehistoric libc.so.5 or the 
> > > program itself are broken.
> > I believe it shows clear regression in latest 2.6.25 kernel.
> 
> I am still not completely sure. It might be a regression, but it also 
> might just trigger the bug in ancient version in libc.so.5 which might be 
> fixed in some later version -- are you able to verify that?

I'm in same position as you here. I only have few old binaries :-(.

> > You say it is wrong. Manpages imply otherwise:
> > 
> >        int brk(void *end_data_segment);
> > ...
> > DESCRIPTION
> >        brk()  sets  the  end  of  the  data  segment  to  the  value specified  by
> >        end_data_segment, when that value is reasonable, the system does have enough
> >        memory and the process does not exceed its max data size (see setrlimit(2)).
> > Note it talks about data segment, not about heap, and that seems to
> > imply that BSS and heap are actually one area. 2.6.25 broke that.
> 
> Single Unix Specification talks only about manipulating the break section, 
> see http://opengroup.org/onlinepubs/007908775/xsh/brk.html

SuS:
# The brk() and sbrk() functions are used to change the amount of space
# allocated for the calling process.

It talks about "space for calling process". It does not talk about
heap, and I think it implicitely assumes "bss and heap" are
continuous... 

(It also says return 0 or success, and we return address).

> > > Still, it will probably not fix your particular program crashes, just 
> > > because it will always assume that brk starts immediately after the end of 
> > > the bss, which is plain wrong and has never been assured. Could you please 
> > Can you quote docs that tells me it is plain wrong? 
> 
> See the Single Unix Specification. It doesn't seem to allow you to assume 
> *anything* about start_brk location, seems to me.

I believe it implicitely assumes start_brk is well known,
actually. Otherwise it should have told us how to get start_brk.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
