Return-Path: <linux-kernel-owner+w=401wt.eu-S1751588AbXA0LAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbXA0LAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 06:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbXA0LAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 06:00:08 -0500
Received: from aun.it.uu.se ([130.238.12.36]:39630 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbXA0LAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 06:00:06 -0500
Date: Sat, 27 Jan 2007 11:59:59 +0100 (MET)
Message-Id: <200701271059.l0RAxxP5018994@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org, thomas@tungstengraphics.com
Subject: Re: Support for i386 PATs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 10:20:18 +0100, Thomas Hellström wrote:
> Does anybody have a strong opinion against adding support for
> i386 Page Attribute Tables?
...
> Issues:
> 1) The _PAGE_BIT_PAT will be the same as _PAGE_PSE, and _PAGE_PROTNONE.
> As I understand it, _PAGE_PROTNONE is not used when the page is present, 
> so this might not be an issue.
> What about _PAGE_PSE?
> 
> 2) The PATs need to be setup for each processor just after system boot.
> Where is the best place to do this?

3) Many Intel processors, including at least most P6s and probably
also some P4s, have an erratum which effectively halves the number
of available PAT entries, forcing an OS to make the low 4 and upper
4 PAT entries identical.

I don't know if 4 PAT types suffice for the kinds of uses people
have in mind. But support for PAT would either have to restrict
itself to only 4 PAT types, or ensure that it is only enabled on
new enough processors where it actually works.

You will need to read all available Intel errata sheets (spec updates)
to determine which processors are affected and which are OK.

/Mikael
