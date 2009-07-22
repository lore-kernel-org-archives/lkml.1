Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbZGVLPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbZGVLPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 07:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZGVLPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 07:15:19 -0400
Received: from tango.0pointer.de ([85.214.72.216]:50277 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZGVLPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 07:15:17 -0400
Date: Wed, 22 Jul 2009 13:14:52 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090722111452.GA24954@tango.0pointer.de>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk> <20090721162312.GA25151@tango.0pointer.de> <20090721173247.158a6292@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721173247.158a6292@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21.07.09 17:32, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

> 
> > Sounds good to me. Though tbh, in my eyes the "proper" fix for this
> > whole problem would be something which would enable userspace to
> > poll() for VT changes. Having blocking ioctl()s still requires most
> 
> The question there is what device do you poll(). It's easy enough to
> magic up a separate vtevent device I guess.

Hmm, maybe we could just use the usual console devices and use SIGERR
or SIGURG or something like that to signal those events? And then have
an ioctl() to actually read them?

> > But OTOH I guess 2 threads are still better than the old situation
> > requiring processes to run 64 threads for listening for VT changes.
> > 
> > Oh, and one more note: instead of padding the struct it would probably
> > be more future-proof to simply pass the struct size in addition to the
> > struct to the ioctl().
> 
> Padding is a lot simpler and less likely to cause bugs later
> (typecasting, mischecking of sizes etc). For the kernel I favour
> simplicity. A vtevent poll/read interface would be even cleaner so I will
> think about that a bit further.

But this isn't a kernel-internal iface, but something exposed to
userspace. Userspace interfaces should be designed cleanly and
future-proof. And padding structs is just painful and unflexible,
since you might end up not reserving enough space for your future
extensions, however until those extensions actually happen you always
pass uneeded memory to the kernel.

But uh, then again, everything's better than the current situation. As
long as we get something that doesn't require 64 threads for watching
VT switches I am happy.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
