Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZKLFkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZKLFkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZKLFkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:40:16 -0500
Received: from 1wt.eu ([62.212.114.60]:51045 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZKLFkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:40:15 -0500
Date: Thu, 12 Nov 2009 06:40:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Thrailkill <matt.thrailkill@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091112054004.GA15925@1wt.eu>
References: <20091110224222.GA28648@1wt.eu> <4AF9ED78.3000106@zytor.com> <20091111055220.GA560@1wt.eu> <4AFA569E.9040206@zytor.com> <20091111063617.GD560@1wt.eu> <4AFA6E50.7030808@zytor.com> <20091111093258.GE560@1wt.eu> <a91053ef0911111823v52669d18p7e5812076a63f03e@mail.gmail.com> <20091112052754.GB15679@1wt.eu> <4AFB9DAE.4080601@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFB9DAE.4080601@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 09:31:26PM -0800, H. Peter Anvin wrote:
> On 11/11/2009 09:27 PM, Willy Tarreau wrote:
> > 
> > Right. However we just noticed that with the KVM emulator, you
> > can make it loop for a long time if you feed it with prefixes
> > only. For instance, write a function which does zillions of 0x66
> > (data size prefix) then return (0xC3) : 66 66 66 ... 66 C3.
> > 
> > This is typically the sort of things we must be very careful about
> > in emulators, because we don't want users to steal large amounts
> > of system CPU time doing nothing.
> > 
> 
> That is a (serious) bug in the KVM interpreter, and indeed the exact
> kind of issues interpreters tend to have... which is why I'd like one
> piece of code with one set of bugs, and more eyeballs on that one piece
> of code so they can be fixed.

Well, I could try to work on a fix (basically the same principle as in
mine, with prefix flags), but I simply don't know how to test the code.
I've never experimented with KVM yet and learned it embeds an emulator
for the first time a few days ago in this thread :-/ If it's easy to
make use of it, I'm not opposed to try.

Willy

