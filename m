Return-Path: <linux-kernel-owner+w=401wt.eu-S1161323AbXBGOjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161323AbXBGOjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161336AbXBGOjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:39:45 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:60271 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161323AbXBGOjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:39:44 -0500
Date: Wed, 7 Feb 2007 15:39:38 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Oleg Verych <olecom@flower.upol.cz>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in
 localversion files
In-Reply-To: <20070206012208.050237000@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0702071537530.14457@scrub.home>
References: <20070206011819.160359000@flower.upol.cz> <20070206012208.050237000@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 6 Feb 2007, Oleg Verych wrote:

> -nullstring :=
> -space      := $(nullstring) # end of line
> +pattern = ".*/localversion[^~]*"
> +string  = $(shell cat /dev/null \
> +	   `find $(objtree) $(srctree) -maxdepth 1 -regex $(pattern) | sort`)

Calling find here is overkill, if the same can be done with standard make 
functions. I very much prefer to just add the damn $(notdir ...) and be 
done with it.

bye, Roman
