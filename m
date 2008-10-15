Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYJORc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYJORc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYJORcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:32:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44415 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYJORct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:32:49 -0400
Date: Wed, 15 Oct 2008 20:32:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, zippel@linux-m68k.org, sam@ravnborg.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [2.6 patch] HID: fix default building of all quirky devices
Message-ID: <20081015173245.GA19255@cs181140183.pp.htv.fi>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi> <20081015073011.GE20183@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz> <alpine.LFD.2.00.0810151002120.3288@nehalem.linux-foundation.org> <alpine.LFD.2.00.0810151009350.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810151009350.3288@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:17:27AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 15 Oct 2008, Linus Torvalds wrote:
> > 
> > And notice how you mis-use select. That's not how to disable a question. A 
> > question gets disabled by just doing an "if xyz" on the question itself, 
> > like Adrian did.
> 
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

For me the more obvious way was what I did, but I agree that your 
solution looks better.

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

