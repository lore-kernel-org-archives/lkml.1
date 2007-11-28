Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbXK1K5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbXK1K5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbXK1K5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:57:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:49754 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607AbXK1K5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:57:14 -0500
Date: Wed, 28 Nov 2007 11:59:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: murtuja bharmal <murtuja_bharmal@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Linux 2.6 kernel module compilation without using KBUILD
Message-ID: <20071128105900.GA16537@uranus.ravnborg.org>
References: <20071128090046.GA15067@uranus.ravnborg.org> <180651.51647.qm@web36715.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <180651.51647.qm@web36715.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> My intention is  to just understand whole  
> process of making kernel module.

The short story....
kbuild knows that .o files listed with obj-m are modules.
So if you have:
   obj-m := foo.o

the kbuild will know that it has to build a module named foo.o.
If foo.o consist of composite objects then kbuild
is told so using:
    foo-y := bar.o baz.o

So in this case kbuild will build bar.o and baz.o and
use these for the resulting module named foo.

When building baz.o kbuild uses make to search for the source file.
First it look for baz.c - if it fails it look for baz.s
Does both fail kbuild give up (there are some corner cases but ignore that).

When foo.o is ready is uses some linker magic to link in version information
and the end result is foo.ko.

foo.ko has a number of unresolved symbols that are:
1) during build time checked if kernel or other modules define them
2) during load time they are resolved

The above is general stuff - if you need more details please be specific.

	Sam
