Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYLFXZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYLFXZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 18:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYLFXZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 18:25:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbYLFXZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 18:25:16 -0500
Date: Sat, 6 Dec 2008 15:24:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Andrew <nick@nick-andrew.net>
cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC] Recursive printk
In-Reply-To: <20081206231626.GK5957@mail.local.tull.net>
Message-ID: <alpine.LFD.2.00.0812061522120.3425@nehalem.linux-foundation.org>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net> <20081205232016.366765e2.akpm@linux-foundation.org> <1228549357.13046.618.camel@localhost> <20081206084038.GG5957@mail.local.tull.net> <1228554693.13046.624.camel@localhost>
 <20081206231626.GK5957@mail.local.tull.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Dec 2008, Nick Andrew wrote:
>
> I agree completely. I was hoping somebody could tell me how to include
> '%v' in gcc's acceptable list, but it seems impossible. The alternative
> then is to use '%pV%s' which gcc _should_ like (I haven't tested it,
> but it seems reasonable) and reverse the order of the fmt and args
> in the function call arguments.

Don't do %pV%s, do just %pV, and pass it a pointer to a struct, something 
like

	struct va_format {
		const char *fmt;
		va_list va;
	};

and make people who use this just always pass things around like that.

(Maybe use "va_list *va" to add another level of indirection if necessary)

		Linus
