Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZEJNao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZEJNao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 09:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZEJNae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 09:30:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36861 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024AbZEJNae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 09:30:34 -0400
Date: Sun, 10 May 2009 14:29:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keir Fraser <keir.fraser@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Linux@zytor.com" <Linux@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
Message-ID: <20090510142928.66bb57bb@lxorguk.ukuu.org.uk>
In-Reply-To: <C62C5B3C.AB1A%keir.fraser@eu.citrix.com>
References: <4A05CD29.6050505@zytor.com>
	<C62C5B3C.AB1A%keir.fraser@eu.citrix.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There exists at least one processor erratum where the CPU will use
> > PAT[4-7] when the user requested PAT[0-3].  For those CPUs, it is unsafe
> > for *any* OS to have PAT[4-7] != PAT[0-3].
> 
> Would it be unreasonable for us to disable PAT on such processors?

That would be a regression as far as Linux is concerned. They work
perfectly well providing you stick to four PAT entries (which is enough
for any Linux system). I'm not sure how Windows handles this but that
might also matter for Xen I guess.

> have matching PAT configuration. No elfnote would mean use Xen's existing
> PAT setup (or if that's very dangerous then disable PAT altogether, perhaps
> dependent on CPU model/stepping?).

Hiding it on errata hit processors if the guest cannot support PAT
safely on such processors sounds a good policy and its one being a
hypervisor you can do neatly.

There are quite a few different CPUs with PAT errata. I've no idea why
there are so many errata about that specific bit.

Alan
