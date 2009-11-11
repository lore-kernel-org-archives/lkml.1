Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbZKKQW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbZKKQW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbZKKQW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:22:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbZKKQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:22:58 -0500
Message-ID: <4AFAE320.6030707@zytor.com>
Date: Wed, 11 Nov 2009 08:15:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu> <20091111102136.407105f4@lxorguk.ukuu.org.uk> <20091111104359.GJ560@1wt.eu>
In-Reply-To: <20091111104359.GJ560@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 02:43 AM, Willy Tarreau wrote:
> 
> well, ironically the KVM decoder can decode an infinite string
> of prefixes while the very simple and limited one in the patch
> I showed did correct checks for invalid cases (multiple segments,
> repeated locks, etc...). It would only accept one data size prefix,
> one address size prefix, one lock and one segment prefix.
> 
> I have nothing against the KVM one, it's just that it's a
> full-featured emulator while we were speaking about a 686
> emulators for lower-end processors. 98% of the instructions
> supported by KVM will never be used for that purpose. This
> is where I see a waste. We're comparing 7000 lines of code
> supporting 64-bit, real mode, NX, etc... to 400. I fail to
> see how we can guarantee that we do it right in that larger
> code (and the example above proves it wrong).
> 
> And as you said, NX is not an issue on the CPUs we're
> targetting.
> 

RIGHT NOW. Except that, guess what, once we have emulation in the
kernel, people are going to demand new instructions to cover *new* gaps
in the instruction set.  And yes, this is going to mean 64 bits and what
not.

The main reason to unify with KVM is not because KVM is doing everything
right (I am perfectly aware that it doesn't), but because I don't really
want to see a plethora of half-arsed emulators spread across the kernel,
each with its own bugs.  If unified, at least there is one codebase
which can get fixed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

