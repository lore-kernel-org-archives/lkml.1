Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbZKLF2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbZKLF2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZKLF2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:28:15 -0500
Received: from 1wt.eu ([62.212.114.60]:51035 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZKLF2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:28:14 -0500
Date: Thu, 12 Nov 2009 06:27:54 +0100
From: Willy Tarreau <w@1wt.eu>
To: Matt Thrailkill <matt.thrailkill@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091112052754.GB15679@1wt.eu>
References: <4AF9E61B.5090407@zytor.com> <20091110222031.GA22911@elte.hu> <20091110224222.GA28648@1wt.eu> <4AF9ED78.3000106@zytor.com> <20091111055220.GA560@1wt.eu> <4AFA569E.9040206@zytor.com> <20091111063617.GD560@1wt.eu> <4AFA6E50.7030808@zytor.com> <20091111093258.GE560@1wt.eu> <a91053ef0911111823v52669d18p7e5812076a63f03e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a91053ef0911111823v52669d18p7e5812076a63f03e@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 06:23:14PM -0800, Matt Thrailkill wrote:
> On Wed, Nov 11, 2009 at 1:32 AM, Willy Tarreau <w@1wt.eu> wrote:
> > All I can say is that executing a NOP results in no state change in
> > the processor except the instruction pointer which points to the
> > next instruction after execution. Since a NOP changes nothing, it
> > cannot be used alone to provide any privilege, access to data or
> > any such thing. Since it does not perform any jump, it cannot either
> > be used to take back control of the execution flow. And it is certain
> > that the next instruction after it will be executed, so if the NOP
> > crosses a page boundary and completes on a non-executable one, the
> > next instruction will trigger the PF.
> >
> > So I can't see how a NOP can be used to circumvent any protection.
> 
> So a nop(l) sled won't be a problem, right?

Right. However we just noticed that with the KVM emulator, you
can make it loop for a long time if you feed it with prefixes
only. For instance, write a function which does zillions of 0x66
(data size prefix) then return (0xC3) : 66 66 66 ... 66 C3.

This is typically the sort of things we must be very careful about
in emulators, because we don't want users to steal large amounts
of system CPU time doing nothing.

Regards,
Willy

