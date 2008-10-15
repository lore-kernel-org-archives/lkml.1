Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYJOWyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYJOWyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbYJOWyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:54:16 -0400
Received: from styx.suse.cz ([82.119.242.94]:48077 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754731AbYJOWyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:54:15 -0400
Date: Thu, 16 Oct 2008 00:54:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Adrian Bunk <bunk@kernel.org>, zippel@linux-m68k.org, sam@ravnborg.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [2.6 patch] HID: fix default building of all quirky devices
In-Reply-To: <alpine.LFD.2.00.0810151009350.3288@nehalem.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0810160050180.26779@jikos.suse.cz>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi> <20081015073011.GE20183@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz> <alpine.LFD.2.00.0810151002120.3288@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0810151009350.3288@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Linus Torvalds wrote:

> > Hmm ... I am not really sure, isn't this a bug in Kconfig?
> Not really, more of a misfeature.
> That said, even if we were to consider it a bug, Adrian's patch is 
> obviously the better way to do it. You shouldn't do non-local dependencies 
> (have one config option select fifty other ones), when the local ones are 
> clearer and more readable (have one config option just describe its *own* 
> dependencies).

I agree. 

And even though I really think this is at least a misfeature, it's indeed 
properly documented in Documentation/kbuild/kconfig-language.txt, so I am 
really the only one to blame here.

On Wed, 15 Oct 2008, Linus Torvalds wrote:

> Side note: Adrian too has a very odd and non-obvious way of doing this.
> 
> His patch did config entries like
> 
> 	config HID_BRIGHT
> 		tristate "Bright" if EMBEDDED
> 		default USB_HID
> 		depends on USB_HID
> 
> which is a really odd way to express this. The much more natural one is
> 
> 	config HID_BRIGHT
> 		tristate "Bright" if EMBEDDED
> 		depends on USB_HID
> 		default y
> 
> since there's no point in saying "default USB_HID" + "depends on USB_HID", 
> and that's just confusing. Since it depends on USB_HID, the "default y" 
> will automatically degrade to whatever USB_HID was set to.

Hmm, yes, looks slightly better.

I see you haven't pulled Adrian's fix from my tree yet. So please drop my 
latest pull request, I will do it the "depens on + default y" way and send 
you a new one shortly. There have been some more VID/PID additions 
accumulated in the meantime anyway, so I'll send them too within a new 
pull request.

-- 
Jiri Kosina
