Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZJLSb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZJLSb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbZJLSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:31:55 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:43795 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757568AbZJLSby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:31:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VkYfcb4vs1hPalyD1a6zYYKgH/VGdpl/B1DaTaWHBONlpvpVQWJMUjd9sk1LNtN10E8GVkqLei52Z5u1LuxU4Mm2lSrPj+XtYbKGW3MGVTZ8hGHm1vkfoaTsQ+QMOQrn;
Date: Mon, 12 Oct 2009 11:30:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Always print panic message on current console
Message-ID: <20091012113055.13d3b7e3@jbarnes-g45>
In-Reply-To: <4AD37478.2070204@bwalle.de>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
	<1255207870-24496-6-git-send-email-bernhard@bwalle.de>
	<87d44sh5uj.fsf@basil.nowhere.org>
	<4AD37478.2070204@bwalle.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 20:24:56 +0200
Bernhard Walle <bernhard@bwalle.de> wrote:

> Andi Kleen schrieb:
> > Bernhard Walle <bernhard@bwalle.de> writes:
> > 
> >> The kernel offers with TIOCL_GETKMSGREDIRECT ioctl() the
> >> possibility to redirect the kernel messages to a specific console.
> >>
> >> However, since it's not possible to switch to the kernel message
> >> console after a panic(), it would be nice if the kernel would
> >> print the panic message on the current console.
> > 
> > The basic idea is good, but you really need to call this in a lot
> > more places, which print some addition needed information before
> > the panic. The one liner panic is often not enough to decide what
> > went wrong. Example are machine checks, oopses, probably more.
> > 
> > In general for the recent work to switch the video mode on panic
> > we need a generalized hook for this anyways, so you could use
> > some generalized function.
> 
> Is that video switch called in a panic notifier list or does that
> introduce a new hook?
> 
> One problem is that kexec is executed before the panic notifier. Which
> is okay for printk(), but it would be very good if the video switch
> would occur before kexec.

It's called in the panic notifier atm.  Yeah sounds like kexec vs
notifiers should be reordered a bit (or the current panic notifier
should be split into notify and "yes we actually failed to do anything"
cases).

-- 
Jesse Barnes, Intel Open Source Technology Center
