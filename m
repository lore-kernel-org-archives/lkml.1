Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYKBSPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYKBSPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYKBSOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:14:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756689AbYKBSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:14:14 -0500
Date: Sun, 2 Nov 2008 10:13:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] el3_common_init() should be __devinit, not __init
In-Reply-To: <20081101211724.GA16941@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0811021008060.3483@nehalem.linux-foundation.org>
References: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk> <20081101191250.GA7588@x200.localdomain> <20081101191614.GA28946@ZenIV.linux.org.uk> <20081101192757.GA7622@x200.localdomain> <20081101211724.GA16941@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Nov 2008, Sam Ravnborg wrote:
> 
> For cpuinit/cpuexit the gain turned out to be minimal.

Quite frankly, I'm not convinced.

Yeah, yeah, most distro's end up always enabling CPU hotplug due to 
suspend/resume, but:

 - desktop PC's aren't where most memory pressures are anyway

 - on UP, CONFIG_HOTPLUG_CPU isn't on even if you do have suspend/resume

 - we should still care about embedded devices, and while some of them are 
   growing up (and having SMP and not caring about a few tens of kB of 
   memory), I don't think that's a valid argument for the other ones.

So. I'd rather we try to keep our init sections, and continue to spend 
effort on fixing them. If at all possible.

		Linus
