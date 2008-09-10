Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYIJPcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYIJPcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYIJPcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:32:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:35996 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYIJPcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lJ/AKNgZLT3Rkkfd0I7DDGdwFRXYEnSe6AAc0tkhr8h8Iav6xJwp33crXMYGP9K4TS
         XndJaF5seww7oOrSnQzfiX51rXQZxn1xRZ5o9L3v6+0+BZ4fuG7iAa1syp5Zc4kaGWls
         TsdGJpgclQfBO5MVBMsfkHibqToyrcADV84+8=
Date: Wed, 10 Sep 2008 11:32:14 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: akpm@osdl.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: mousedev: Emulate right and middle buttons
	for single-button touchpads
Message-ID: <20080910153213.GA6940@USFSHXP-002051>
References: <48C0893C.6060901@euromail.se> <20080910125228.GA25221@anvil.corenet.prv> <48C7DF08.4060208@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C7DF08.4060208@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 04:51:52PM +0200, Henrik Rydberg wrote:
> Greetings Dmitry,
> 
> > On Fri, Sep 05, 2008 at 03:19:56AM +0200, Henrik Rydberg wrote:
> >> On most linux-based systems, the right and middle buttons are used
> >> extensively. On computers lacking either of those buttons, such as
> >> the Apple Macbooks, emulation is needed. This patch adds emulation
> >> of the missing buttons via two-fingers-and-click and three-fingers-
> >> and-click operations, which has recently become standard, both in
> >> MacOS and in the Xorg synaptics driver.
> >>
> > 
> > The standard way of emulating right and middle button presses for
> > "button-deficient" devices is to use Macintosh emulation
> > (MAC_EMUMOUSEBTN) that works not only for touchpads but for regular mice
> > as well.
> 
> I have a hard time believing that in five years from now, people will
> still consider pressing a key on the keyboard the standard way to
> emulate a right click.

Well, what other options do you have if your device has only one
button and nothing else (i.e. it's a mouse, not a touchpad)? Anyway, I
hope in 5 years distros will switch to pure evdev-based interfaces and
won't use mousedev at all.

> Nevertheless, I can see the point in moving
> away from user-land decisions in the kernel. I will not pursue this one
> further, although it is a rather neat piece of functionality.
> 
> > Overall I don't think we should enhance mousedev for scenarios where
> > proper solution is to install Synaptics X driver. This also goes for
> > your other patch improving tapping in mousedev.
> 
> Regarding the tapping patch; it is addressing the correctness of
> already implemented functionality. I can see nothing wrong with that.
>

My position that since the isssue can be "fixed" by simply installing
the proper X driver I'd rather not include it. Mousedev purpose is to
provide good enough emulation in absence of a native driver and that's
it. Also, the default value would not work well on high-resiolution
devices (like Synaptics) and would require user fiddling with kernel
parameters - not worth it in my opinion.

-- 
Dmitry
