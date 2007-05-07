Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbXEGAio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbXEGAio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXEGAio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:38:44 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1732 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXEGAin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:38:43 -0400
Date: Mon, 7 May 2007 02:38:36 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: kconfig: error out if recursive dependencies are found
In-Reply-To: <20070506074038.GB6492@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705070221500.1479@scrub.home>
References: <20070502201741.GD9044@uranus.ravnborg.org>
 <20070506073615.GA6492@uranus.ravnborg.org> <20070506074038.GB6492@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 6 May 2007, Sam Ravnborg wrote:

>  	if (sym->flags & SYMBOL_CHECK) {
> -		printf("Warning! Found recursive dependency: %s", sym->name);
> +		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
> +		        sym->prop->file->name, sym->prop->lineno, sym->name);
>  		return sym;
>  	}

If it were that simple to print the location, I had done it already. :)
Try this:

config FOO
        bool
        select BAR
        depends on BAR

config BAR
        bool

I looked into this before, for simple properties one could just remember 
the last checked property via a static variable. The problem are the 
selects which are checked before that loop, here the information from 
where they were selected is not available anymore (at least not easily).

bye, Roman
