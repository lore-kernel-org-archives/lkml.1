Return-Path: <linux-kernel-owner+w=401wt.eu-S938633AbXHJSTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938633AbXHJSTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbXHJSTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:19:08 -0400
Received: from [81.2.110.250] ([81.2.110.250]:44762 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757515AbXHJSTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:19:06 -0400
Date: Fri, 10 Aug 2007 19:25:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, Steven@smtp2.linux-foundation.org,
       akpm@linux-foundation.org,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       virtualization@lists.linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
Message-ID: <20070810192543.605f350f@the-village.bc.nu>
In-Reply-To: <5d6222a80708101108y62ebfa26n9f47bfc52b48f4a8@mail.gmail.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
	<11865468394005-git-send-email-gcosta@redhat.com>
	<11865468431616-git-send-email-gcosta@redhat.com>
	<200708081144.04119.ak@suse.de>
	<46BB5258.8040609@goop.org>
	<20070809190303.214e5457@the-village.bc.nu>
	<5d6222a80708101108y62ebfa26n9f47bfc52b48f4a8@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 15:08:35 -0300
"Glauber de Oliveira Costa" <glommer@gmail.com> wrote:

> On 8/9/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > What's the EBDA actually used for?  The only place which seems to use
> > > ebda_addr is in the e820 code to avoid that area as RAM.
> >
> > It belongs to the firmware.
> 
> Wouldn't it be better, then, to just skip this step unconditionally if
> we are running a paravirtualized guest? What do we from doing it?

An EBDA is an optional BIOS feature so providing you virtualise the
relevant entry in the zero page (to avoid guest applications trying to
scan the EBDA for some system tables they may want to use like DMI) as
a zero entry you can ignore the EBDA.

That probably the right thing to do since the host EBDA won't match the
guest environment and the guest might migrate anyway
