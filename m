Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYH2OST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYH2OST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYH2OSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:18:09 -0400
Received: from gw.goop.org ([64.81.55.164]:44781 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111AbYH2OSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:18:08 -0400
Message-ID: <48B8051E.2050401@goop.org>
Date: Fri, 29 Aug 2008 07:18:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Rafa=3F_Mi=3Fecki?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org>	<86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>	<48B76CE0.5010309@goop.org> <20080829102547.655440bf@lxorguk.ukuu.org.uk>
In-Reply-To: <20080829102547.655440bf@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>>>  - Clears the reserved memory so we can observe changes to it.
>>>>         
>
> You ought to pick different values on different runs 0x00, 0xFF, 0xAA,
> 0x55 etc...
>   

Yes, that wouldn't be a bad idea.  The corruption we've seen so far is
0->non 0, but we haven't looked for zeroing.

>> Yeah, OK, but I think it should default to ON for now.  The problem is
>> that we had two very different systems (Sony Vaio and Intel desktop)
>>     
>
> So a zillion people should lose a chunk of RAM because of what is
> probably an obscure bug in a single version of a piece of SMM code on two
> systems total ?
>   

Well, we just don't know.  We have two systems which started reporting
problems when I made a small change to how the initial pagetables are
allocated.  Before that they appeared to work fine, though in reality it
was just some other part of the address space being corrupted.  Who
knows how many systems are out there "working fine", except that some
obscure address in the user address space now allows you to write into
kernel memory?

The two systems are *completely different*.  One has a Phoenix BIOS, the
other is AMI.  One is a Sony Vaio, the other is an OEM Intel desktop. 
One corrupts memory on unplugging a HDMI cable, the other corrupts on
suspend/resume.  I don't think this is reassuring, or indicates the
problem has limited scope.

> That appears to be totally out of proportion - plus the defaults are
> *irrelevant* for mass user coverage. If you want large scale coverage ask
> the Fedora, OpenSuSE and Ubuntu people to turn it on for a testing kernel
> release and report back.

The idea is to leave it on by default for a while - maybe a couple of
-rc releases - and see what turns up.  We can turn it off for a release
kernel if people really object, though I'd hope something like Fedora
Rawhide would leave it on.

    J
