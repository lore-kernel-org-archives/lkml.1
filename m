Return-Path: <linux-kernel-owner+w=401wt.eu-S934837AbYD1OPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837AbYD1OPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763151AbYD1OPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:15:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:11787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538AbYD1OPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AtN0rYGp+VqxdswmqhxBlWkHLa7dqN0N1nR4ET+pwtpsaniTnJ1JAqX4+m4qUb86tlH1DdEu+IcyHNLIz7aWxrgj7gTOofmfk9WE8oY3rlDCderCr0gPBj6M6TjbNd9AkLhkM1vjeTcIl8trLysgqbispTtAW121Eyp0+Il1c3o=
Message-ID: <4815DBF6.9010509@googlemail.com>
Date: Mon, 28 Apr 2008 16:15:18 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Mika Fischer <mika.fischer@zoopnet.de>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com> <200801202256.48365.yinghai.lu@sun.com> <20080122165125.GA17992@elte.hu> <200801221623.20861.yinghai.lu@sun.com> <20080426035614.a30afb17.akpm@linux-foundation.org> <48132665.8050202@googlemail.com> <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com> <48159668.5010808@googlemail.com> <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com> <48159ECF.9020004@googlemail.com> <20080428135351.GF3973@elte.hu>
In-Reply-To: <20080428135351.GF3973@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>>> please try v2 version
>>>
>>> http://lkml.org/lkml/2008/4/28/115
>> Box still won't boot with mtrr_chunk_size=1g but without it is perfect 
>> :)) Thx for your work. I've quick tested some games and 3d things , 
>> all are working with this patch really nice.
> 
> excellent. So just to make sure: this box never had proper graphics 
> under Linux (under no previous kernel), due to the way the BIOS has set 
> up the MTRR's, right?

The box is really new so far I tested 2.6.24* 2.6.25 , linux-next , current git from
which no one worked. And yes is right graphics under Linux didn't worked right without 
patch from http://lkml.org/lkml/2008/4/28/115.

> 
> so fixing up the MTRRs during bootup, no matter how dangerous in theory, 
> is pretty much the best option to get your system to work fine under 
> Linux, with that specific Xorg version?

Yes.

I run :

xorg-server 1.4.0.90-5 ( it has all fixes from server-1.4-branch )
mesa 7.0.2-2
xf86-video-intel 2.3.0-1

Probably I have to replace 2x2G with 2x1G to get it work without this patch but it is something I don't really want to do =)

Also I'm not sure whatever this is an BIOS bug ? I could contact ASUS people if someone tells me what is wrong with the BIOS.

> 
> i think we should still try to make this a non-default option because 
> modern Xorg should not have any need to touch MTRRs. Perhaps a .config 
> dependent on CONFIG_DANGEROUS ;-)

Hmm 1.4.0.90 is not that old , is it ?

> 
> 	Ingo
> 

Gabriel
