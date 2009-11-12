Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZKLFid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZKLFid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZKLFid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:38:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZKLFic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:38:32 -0500
Message-ID: <4AFB9DAE.4080601@zytor.com>
Date: Wed, 11 Nov 2009 21:31:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Matt Thrailkill <matt.thrailkill@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF9E61B.5090407@zytor.com> <20091110222031.GA22911@elte.hu> <20091110224222.GA28648@1wt.eu> <4AF9ED78.3000106@zytor.com> <20091111055220.GA560@1wt.eu> <4AFA569E.9040206@zytor.com> <20091111063617.GD560@1wt.eu> <4AFA6E50.7030808@zytor.com> <20091111093258.GE560@1wt.eu> <a91053ef0911111823v52669d18p7e5812076a63f03e@mail.gmail.com> <20091112052754.GB15679@1wt.eu>
In-Reply-To: <20091112052754.GB15679@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 09:27 PM, Willy Tarreau wrote:
> 
> Right. However we just noticed that with the KVM emulator, you
> can make it loop for a long time if you feed it with prefixes
> only. For instance, write a function which does zillions of 0x66
> (data size prefix) then return (0xC3) : 66 66 66 ... 66 C3.
> 
> This is typically the sort of things we must be very careful about
> in emulators, because we don't want users to steal large amounts
> of system CPU time doing nothing.
> 

That is a (serious) bug in the KVM interpreter, and indeed the exact
kind of issues interpreters tend to have... which is why I'd like one
piece of code with one set of bugs, and more eyeballs on that one piece
of code so they can be fixed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

