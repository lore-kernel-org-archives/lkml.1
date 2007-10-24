Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbXJXSMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbXJXSMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760913AbXJXSLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:11:36 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:38271 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760843AbXJXSLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:11:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=fF1/mqG/1WJN99DJElyRUMtP+iD3QSgWcm0ZthXCP7RM2Xby9bwgBOdwbuwBQmD99+FtmagSAdYYr2n7mHuVgrDu///bEUF63PPxLfxpAJH87qWoEmINyEoQOoKG4Yov;
Message-ID: <471F8AC5.9080300@simon.arlott.org.uk>
Date: Wed, 24 Oct 2007 19:11:17 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
References: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de>
In-Reply-To: <20071024125533.GE30533@stusta.de>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/07 13:55, Adrian Bunk wrote:
> On Wed, Oct 24, 2007 at 12:50:29PM +0100, Simon Arlott wrote:
>> I currently have an LSM that only handles permissions for socket_bind
>> and socket_listen, I load it and then "capability" as secondary on
>> boot - but now I can't because the LSM framework is now just the LS
>> framework.
>> 
>> Why can't this "static LSM" change be a Kconfig option?
>> (I don't want to have to maintain my own reverted copy of security/,
>> or compile this into the kernel because then I can't ever modify and
>> reload it without rebooting.)
> 
> Let's start with the more important questions:
> 
> Did you submit your LSM for inclusion into the kernel?

No, because the interface for configuring it would be rejected... I have 
a /proc file which I write a binary configuration file to. This works 
fine for me but it would take a lot of work to write a proper interface 
- which I'm still not sure how to do*.

That doesn't solve the problem that it's no longer possible to reload LSM 
modules to make changes at runtime. Why should I have to reboot to change 
something from now on when it works ok? The reasoning seems to be based 
around a dislike of some out of tree modules. (Although it doesn't look 
like there's appropriate locking around the register/unregister process.)


* (I've got a list of access rules which are scanned in order until one of 
them matches, and an array of one bit for every port for per-port default 
allow/deny - although the latter could be removed.
http://svn.lp0.eu/simon/portac/trunk/)

-- 
Simon Arlott
