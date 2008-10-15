Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYJORTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYJORTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYJORTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:19:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbYJORTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:19:37 -0400
Date: Wed, 15 Oct 2008 10:17:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: Adrian Bunk <bunk@kernel.org>, zippel@linux-m68k.org, sam@ravnborg.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [2.6 patch] HID: fix default building of all quirky devices
In-Reply-To: <alpine.LFD.2.00.0810151002120.3288@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810151009350.3288@nehalem.linux-foundation.org>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi> <20081015073011.GE20183@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz>
 <alpine.LFD.2.00.0810151002120.3288@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Linus Torvalds wrote:
> 
> And notice how you mis-use select. That's not how to disable a question. A 
> question gets disabled by just doing an "if xyz" on the question itself, 
> like Adrian did.

Side note: Adrian too has a very odd and non-obvious way of doing this.

His patch did config entries like

	config HID_BRIGHT
		tristate "Bright" if EMBEDDED
		default USB_HID
		depends on USB_HID

which is a really odd way to express this. The much more natural one is

	config HID_BRIGHT
		tristate "Bright" if EMBEDDED
		depends on USB_HID
		default y

since there's no point in saying "default USB_HID" + "depends on USB_HID", 
and that's just confusing. Since it depends on USB_HID, the "default y" 
will automatically degrade to whatever USB_HID was set to.

			Linus
