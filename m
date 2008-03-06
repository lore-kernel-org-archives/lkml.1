Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbYCFJCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbYCFJCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759339AbYCFJC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:02:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbYCFJCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:02:16 -0500
Date: Thu, 6 Mar 2008 04:01:09 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Michael Matz <matz@suse.de>,
       Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction  flag
Message-ID: <20080306090109.GD24887@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <87ablcgs2y.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ablcgs2y.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 09:44:05AM +0100, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> > Richard Guenther wrote:
> > > We didn't yet run into this issue and build openSUSE with 4.3 since
> > > more than
> > > three month.
> > >
> > 
> > Well, how often do you take a trap inside an overlapping memmove()?
> 
> That was the state with older gcc, but with newer gcc it does not necessarily
> reset the flag before the next function call.
> 
> so e.g. if you have
> 
>         memmove(...)
>         for (... very long loop .... ) {
>                 /* no function calls */
>                 /* signals happen */
>         }
> 
> the signal could see the direction flag

memmove is supposed to (and does) do a cld insn after it finishes the
backward copying.

	Jakub
