Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbYBVNNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbYBVNNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYBVNN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:13:29 -0500
Received: from main.gmane.org ([80.91.229.2]:34729 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbYBVNN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:13:28 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Fri, 22 Feb 2008 13:13:19 +0000 (UTC)
Message-ID: <loom.20080222T130746-405@post.gmane.org>
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802190017.04432.mb@bu3sch.de> <20080218234212.GA25680@uranus.ravnborg.org> <200802190101.27429.mb@bu3sch.de> <20080219053229.GB25680@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 78.115.177.6 (Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.12) Gecko/20080129 Iceweasel/2.0.0.12 (Debian-2.0.0.12-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam <at> ravnborg.org> writes:

> 
> In at least 99% of the cases this is OK and the check has found
> several bugs where things would not have worked due to different
> alignmnet between kernel and userland. Just think about the
> issues in a mixed 32/64 bit world.
> 
I don't see how this check is supposed to work.
For some arch userspace can have different alignement depending on compilation
option :
- x86_64 : 32 or 64 bits mode
- arm : 32 bits or thumb mode
- mips : 32 bits or mips16 mode
[...]

The check is done only for one case ?


> In this particular case you _could_ be right that it would work
> on ARM userland. But the only way to be sure is to pad the
> structure so it become 8 byte in size.
> Or as was recently done in the m68k case to tell the
> compiler to specifically align it to 8 byte boundary.
An easy way to fix this is just to issue a warning but not an error. So it could
ignored on cross compilation case.

Matthieu

