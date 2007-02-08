Return-Path: <linux-kernel-owner+w=401wt.eu-S1423448AbXBHVnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423448AbXBHVnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423447AbXBHVnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:43:03 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41005 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423448AbXBHVnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:43:00 -0500
Date: Thu, 8 Feb 2007 13:42:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=B3n?= <jamagallon@ono.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <20070208221317.5beedaeb@werewolf-wl>
Message-ID: <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <20070208221317.5beedaeb@werewolf-wl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1725508962-1170970967=:8424"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1725508962-1170970967=:8424
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Thu, 8 Feb 2007, J.A. Magallón wrote:
> 
> Perhaps the problem is that gcc warns you something like 'if you care
> anything about the sign behaviour of what you send to strlen() you're doomed'.

But you *cannot* care. That's the point. The warning is insane. For any 
function that takes "char *", you very fundamentally *cannot* care about 
the signedness of the argument, because doing so would be wrong. If you 
do care, you're already buggy.

> Ie, you declared the var unsigned, so you care about it. But I can do
> anything without any regard to the sign.

That makes no sense. 

First off, "strlen()" doesn't care about the sign of the buffer, so it's a 
bad example anyway. But take something that *can* care, namely "strcmp()", 
which can return different things depending on whether "char" is signed or 
not (is 0xff larger than 0x00? Depends on whether char is signed or 
not..).

But THE CALLER CANNOT AND MUST NOT CARE! Because the sign of "char" is 
implementation-defined, so if you call "strcmp()", you are already 
basically saying: I don't care (and I _cannot_ care) what sign you are 
using.

So having the compiler warn about it is insane. It's like warnign about 
the fact that it's Thursday today. It's not something the programmer cares 
about.

		Linus
---1463790079-1725508962-1170970967=:8424--
