Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbXJYLoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbXJYLoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXJYLoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:44:21 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:33075 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbXJYLoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:44:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=LyghZCfBlpVN88fADjFPcTLoL3BSZ92TpqwKKm8/hQZz7hsjkZHBKaWwgbJoaKsn/Bcli53xd+GNP7RelDj81m+iqhMDmrLVSyZNrF+i6ao2piwQcqYE4IMD4uMb2oCp;
Message-ID: <17771.simon.1193312648@5ec7c279.invalid>
In-Reply-To: <20071024223124.GI30533@stusta.de>
References: <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
    <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
    <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
    <20071022210956.31f7bbcf@laptopd505.fenrus.org>
    <20071023051642.GA3908@sequoia.sous-sol.org>
    <471E9260.6000704@goop.org>
    <20071023220649.5a76af82@laptopd505.fenrus.org>
    <55615.simon.1193226629@5ec7c279.invalid>
    <20071024125533.GE30533@stusta.de>
    <471F8AC5.9080300@simon.arlott.org.uk>
    <20071024223124.GI30533@stusta.de>
Date: Thu, 25 Oct 2007 12:44:08 +0100
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to 
     static interface)
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Adrian Bunk" <bunk@kernel.org>
Cc: "Chris Wright" <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, October 24, 2007 23:31, Adrian Bunk wrote:
> On Wed, Oct 24, 2007 at 07:11:17PM +0100, Simon Arlott wrote:
>> On 24/10/07 13:55, Adrian Bunk wrote:
>> > On Wed, Oct 24, 2007 at 12:50:29PM +0100, Simon Arlott wrote:
>> >> I currently have an LSM that only handles permissions for socket_bind
>> >> and socket_listen, I load it and then "capability" as secondary on
>> >> boot - but now I can't because the LSM framework is now just the LS
>> >> framework.
>> >>
>> >> Why can't this "static LSM" change be a Kconfig option?
>> >> (I don't want to have to maintain my own reverted copy of security/,
>> >> or compile this into the kernel because then I can't ever modify and
>> >> reload it without rebooting.)
>> >
>> > Let's start with the more important questions:
>> >
>> > Did you submit your LSM for inclusion into the kernel?
>>
>> No, because the interface for configuring it would be rejected... I have
>> a /proc file which I write a binary configuration file to. This works
>> fine for me but it would take a lot of work to write a proper interface
>> - which I'm still not sure how to do*.
>>...
>
> Generally, the goal is to get external modules included into the kernel.
>
> You want to be able to have this functionality and you do not want to
> use SELinux for it.

SELinux couldn't do it when I wrote my own module, it may do now but I
haven't checked - that's also far too much extra configuration overhead
to do something relatively simple.

> But instead of working on getting your code into the kernel you are
> requesting that an API making it easier for you to maintain it
> externally comes back.

It's also much harder to maintain it internally too since it can no
longer be compiled as a module. If it were possible to have to make LSM
usable as a module but without secondary support, that would make
development easier - although secondary support is so trivial I doubt
it makes a difference to the possibility of allowing it to be compiled
as a module again.

> There are other points in this thread that might or might not warrant
> making LSM modular again, but even though it might sound harsh breaking
> external modules and thereby making people aware that their code should
> get into the kernel is IMHO a positive point.

You're only going to be forcing me to spend *my* time developing it into
something that could be accepted into the kernel when it works fine for
me already. Then I'd have to convince the LSM maintainer(s) that it
should be merged - this isn't like an external hardware driver where
there's no existing support in the kernel.


>> Simon Arlott
>
> cu
> Adrian


-- 
Simon Arlott
