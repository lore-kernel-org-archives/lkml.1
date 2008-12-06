Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYLFR1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYLFR1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYLFR1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:27:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbYLFR1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:27:34 -0500
Date: Sat, 6 Dec 2008 09:27:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Andrew <nick@nick-andrew.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/3] Add %v support to vsnprintf()
In-Reply-To: <20081206070003.29149.50293.stgit@marcab.local.tull.net>
Message-ID: <alpine.LFD.2.00.0812060917220.3425@nehalem.linux-foundation.org>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net> <20081206070003.29149.50293.stgit@marcab.local.tull.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Nick Andrew wrote:
>
> Add %v support to vsnprintf()

No can do. gcc will always warn, and I don't want to see an extension that 
will generate unfixable warnings.

If you want to do this, you'd need to do it the same way we did some othe 
printf extensions, ie by not passing the valist entry itself, but 
passing the _pointer_ to it, and using "%pV" as the format modifier.

(Quite frankly, "va_list" can be rather large, so passing a pointer to it 
is probably a better idea anyway).

Of course, gcc may implement "va_list" as an array (or just a pointer) 
internally, and then it will be passed as a pointer anyway (and you'd not 
need the address-of), but that's certainly not in any way guaranteed, and 
is very possibly architecture-dependent.

			Linus
