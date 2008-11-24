Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbYKXJnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbYKXJnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKXJnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:43:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34388 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYKXJnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:43:42 -0500
Date: Mon, 24 Nov 2008 10:53:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] __used is needed for function referenced only from inline asm
Message-ID: <20081124095356.GW6703@one.firstfloor.org>
References: <1227514662-10848-1-git-send-email-edwintorok@gmail.com> <Pine.LNX.4.64.0811240948130.30025@anakin> <873ahhiil1.fsf@basil.nowhere.org> <je7i6twjsp.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <je7i6twjsp.fsf@sykes.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 10:32:54AM +0100, Andreas Schwab wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > Geert Uytterhoeven <geert@linux-m68k.org> writes:
> >>>   */
> >>> -static void noinline __sched
> >>> +static __used noinline void __sched
> >>
> >> Perhaps we should incorporate it into `noinline'?
> >
> > No, we use noinline for other reasons too. Perhaps the other way
> > around though.
> 
> Or just drop noinline here (since there are no callers to inline into
> anyway).

That would seem fragile to me because it could hit later again when
someone changes the code or adds debugging code. Better always
have full annotations, even if you don't need them all at the moment.

-Andi

-- 
ak@linux.intel.com
