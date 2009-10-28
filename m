Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZJ1VFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZJ1VFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbZJ1VFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:05:05 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:36459 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbZJ1VFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:05:04 -0400
Date: Wed, 28 Oct 2009 21:05:08 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       DRI Development Mailing List 
	<dri-devel@lists.sourceforge.net>,
       Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Subject: Re: is avoiding compat ioctls possible?
In-Reply-To: <20091028031904.GA7744@basil.fritz.box>
Message-ID: <alpine.LFD.2.00.0910282055330.9323@eddie.linux-mips.org>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com> <87hbtkjkki.fsf@basil.nowhere.org> <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com> <20091028031904.GA7744@basil.fritz.box>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Andi Kleen wrote:

> > I'm just amazed that compat_ioctl should be required for all new code.
> > 
> > DrNick on irc suggested just doing:
> > if (is_compat_task()) ptr &= 0x00000000FFFFFFFF;
> 
> Such hacks often have problems on BE.

 And then some platforms (i.e. MIPS) require sign-extension rather than 
zero-extension, that is:

if (is_compat_task()) ptr = ((ptr & 0xffffffff) ^ 0x80000000) - 0x80000000;

if doing this explicitly (with compat stuff hardware will do the right 
thing automagically).

  Maciej
