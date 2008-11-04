Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYKDUic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYKDUic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYKDUiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:38:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37685 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYKDUiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:38:23 -0500
Date: Tue, 4 Nov 2008 21:46:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104204655.GG29626@one.firstfloor.org>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <491090F3.5020701@zytor.com> <1225824256.28612.1282966677@webmail.messagingengine.com> <4910A390.409@zytor.com> <20081104203046.GF29626@one.firstfloor.org> <4910AFE5.4020408@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4910AFE5.4020408@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 12:26:13PM -0800, H. Peter Anvin wrote:
> Andi Kleen wrote:
> > 
> > Or again just generate them on demand when the interrupt is set up.
> > If you really have 240 interrupts sources you can afford the 5k likely,
> > but for most there will be only a minimum number of stubs.
> > 
> > Although frankly I suspect there are far easier ways to save 5k of memory.
> > 
> 
> Generating them dynamically is probably pretty ugly too, though.

Why? The only slightly tricky thing is that they need to be in no NX space.
Then it's just a few bytes patched in a template.

> Shrinking the whole table down to 2K by just regularizing the structure
> is trivial, though, and should almost certainly be a win.  The more
> esoteric ideas are probably worse.

Just think how much memory you could safe elsewhere with the same
effort.

-Andi
