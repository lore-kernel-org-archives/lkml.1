Return-Path: <linux-kernel-owner+w=401wt.eu-S1765866AbXE2Ulf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765866AbXE2Ulf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758931AbXE2Ul2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:41:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45517 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbXE2Ul1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:41:27 -0400
Date: Tue, 29 May 2007 22:42:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-rc3: regression: make M=$PWD modules_install does nothing
Message-ID: <20070529204228.GA7738@uranus.ravnborg.org>
References: <200705280634.37420.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705280634.37420.arvidjaar@mail.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey

> This has been working up and including -rc2:

I have tried to reproduce here - but it just works.
I then took a second look at your excellent bug-report and noticed:
> 
> {pts/1}% sudo make -C ~/src/linux-git O=$HOME/build/linux-2.6.22 M=PWD V=1 

that in this commandline you say M=PWD

> modules_install
> make: Entering directory `/home/bor/src/linux-git'
> make -C /home/bor/build/linux-2.6.22 \
>         KBUILD_SRC=/home/bor/src/linux-git \
>         KBUILD_EXTMOD="PWD" -f /home/bor/src/linux-git/Makefile

which tell kbuild that module is in a directory named 'PWD' as seen in the
assignment to KBUILD_EXTMOD in the above line.

Could it be that you by accident omitted a '$' in front of PWD?
This would then tell kbuild that module are in the directory pointed to by $PWD.

	Sam
