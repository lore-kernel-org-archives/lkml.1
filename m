Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXIJMA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXIJMA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXIJMAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:00:18 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40657 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182AbXIJMAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:00:17 -0400
Date: Mon, 10 Sep 2007 14:01:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] build system: section garbage collection for vmlinux
Message-ID: <20070910120140.GA29077@uranus.ravnborg.org>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051940.15653.vda.linux@googlemail.com> <20070905204628.GE30812@uranus.ravnborg.org> <200709061155.52661.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709061155.52661.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Doing a normal kernel build will link vmlinux three or four times.
> > If we introduce --gc-sections we should add a preparational link of
> > vmlinux where we use --gc-sections and skip it for the rest of the links
> > assuming that --gc-sections takes some time for ld to do.
> 
> Yes, this will speed up things a bit.

If we do the --gc-sections trick during the preparational link then we do
not use the arch supplied linker script.
Will it be possible to create a dedicated linker script that is valid
for all architectures and which only include the KEEP() directives for
the diverse sections?

That would also free us from modifying a lot of arch linker scripts uglifying
them even more than they are today.

	Sam
