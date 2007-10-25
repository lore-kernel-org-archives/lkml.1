Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbXJYLis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbXJYLis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXJYLii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:38:38 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:38624 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbXJYLih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:38:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=L3XyBDsN7D5AHNv6imliwHoaafRVqYG5kCAcBDIup7BMoJ6BQv4++NSFAW036iKJajyEHPUOu6dbkQA9MWrdC/bCmnh1kAJFs+ulMZEpwzaN93mH/sc3UaROUtntYcPK;
Message-ID: <16845.simon.1193312300@5ec7c279.invalid>
In-Reply-To: <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil>
References: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
    <200710192226.53233.agruen@suse.de>
    <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
    <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
    <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
    <20071022210956.31f7bbcf@laptopd505.fenrus.org>
    <20071023051642.GA3908@sequoia.sous-sol.org>
    <471E9260.6000704@goop.org>
    <20071023220649.5a76af82@laptopd505.fenrus.org>
    <55615.simon.1193226629@5ec7c279.invalid>
    <20071024125533.GE30533@stusta.de>
    <471F8AC5.9080300@simon.arlott.org.uk>
    <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr>
    <471F9603.9080308@simon.arlott.org.uk>
    <Pine.LNX.4.64.0710242059500.17781@fbirervta.pbzchgretzou.qr>
    <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil>
Date: Thu, 25 Oct 2007 12:38:20 +0100
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to 
     static interface)
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Adrian Bunk" <bunk@kernel.org>, "Chris Wright" <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
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


On Wed, October 24, 2007 22:02, David P. Quigley wrote:
> Apparmor wants to lock down some application, it gives the application
> access to a particular port, and the minimal set of privileges needed to
> execute the application. Since Apparmor is "easy to use" (note the
> quotes are to indicate they aren't my words not sarcasm) and SUSE comes
> with a targeted policy the user isn't concerned with it. Now multiadm
> comes along and an administrator wishes to grant extra rights to a user.
> This is fine with multiadm alone since it is the main security module,
> however we now have to compose this with AppArmor. So an administrator
> runs into an error running his application. Is this because his user
> isn't granted the proper escalated privileges? Is it because AppArmor
> needs an extra rule to run the application?  It could also be that our
> third module has blocked the application because it determined that even
> though multiadm specified that the user should have the elevated
> privileges to run the application that user shouldn't be able to bind to
> that port.
>
> There might be a better example to illustrate the problem however, this
> simple example shows the interdependency of three seemingly simple
> modules. Imagine what happens when people really let loose and implement
> all sorts of crazy ideas and stack them on top of each other. Stacking
> works in things such as file systems because we have a clearly defined
> interface with fixed solid semantics. You could attempt to do that but
> once you have modules that step on each others toes you have to figure
> out a way to reconcile that. It seems to me that you're going to
> introduce usability problems that are hard to deal with.

I agree that it can cause problems, but it's up to the modules themselves
to determine how to combine permissions with their immediate secondary
module.

Instead we now have a static LSM where combining features from one module
means duplicating it in another - then when two modules contain most of
the other's code, but perhaps vastly different configuration mechanisms,
someone will propose removing one of the two...

-- 
Simon Arlott
