Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYAIUiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYAIUiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYAIUh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:37:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38214 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYAIUh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:37:56 -0500
Date: Wed, 9 Jan 2008 21:40:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109204028.GA15612@one.firstfloor.org>
References: <20080109035534.GA30321@basil.nowhere.org> <20080109090956.GA14274@elte.hu> <20080109141908.GB12855@one.firstfloor.org> <20080109152208.GA21280@elte.hu> <20080109155124.GB12923@one.firstfloor.org> <20080109163017.GG17739@elte.hu> <20080109174800.GA15346@one.firstfloor.org> <20080109122559.38bc8c33@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109122559.38bc8c33@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 12:25:59PM -0800, Arjan van de Ven wrote:
> On Wed, 9 Jan 2008 18:48:00 +0100
> > And after all that's still by far the most common system call
> > (not only for databases; i profiled this using systemtap in some
> > loads some time ago and it usually came up with >50%) 
> > and quite important for many workloads.
> > 
> 
> btw be careful with this; the X server uses gettimeofday in it's equivalent of udelay()...
> (and we all know how useful it is to make the delay loops faster ;-)

People tend to make jokes about optimizing the idle loop too, but they're
actually wrong. Exit latency for the idle loop is important -- it 
decides how quickly you can react to load changes on idle CPUs.

For short udelays I suspect shorter exit latency is also moderately useful.

But anyways there are plenty of gtod users outside the X server.

e.g. common not user space case is packet timestamps.

-Andi
