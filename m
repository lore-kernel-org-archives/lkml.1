Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbXLFDbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbXLFDbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXLFDba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:31:30 -0500
Received: from fmailhost05.isp.att.net ([204.127.217.105]:56742 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbXLFDb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:31:29 -0500
X-Originating-IP: [74.251.45.146]
Date: Wed, 5 Dec 2007 21:31:26 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
Message-ID: <20071205213126.43548ccf@osprey.hogchain.net>
In-Reply-To: <20071205210003.GA15366@uranus.ravnborg.org>
References: <20071204210433.4d7ee66c@osprey.hogchain.net>
	<20071205210003.GA15366@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2007 22:00:03 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Tue, Dec 04, 2007 at 09:04:33PM -0600, Jay Cliburn wrote:
> > Sam,
> > 
> > This piece of the top-level Makefile in current git causes an
> > out-of-tree driver Makefile to fail.
> > 
> > 101 ifdef O
> > 102   ifeq ("$(origin O)", "command line")
> > 103     KBUILD_OUTPUT := $(O)
> > 104   endif
> > 105 endif
> > 
> > The out-of-tree driver Makefile contains an O=... directive that
> > (correctly) does _not_ specify the kernel source dir, and apparently
> > isn't overridden by the command line either. If in the above
> > Makefile snippet I change "command line" to "file", my out-of-tree
> > make succeeds. What do you think about allowing O= to come from a
> > file in addition to the command line?
> 
> When you change "command line" to "file" you actually makes kbuild
> ignore the O=... value which is why it succeeds.

I'm puzzled by your statement.  Isn't the opposite true?  When using
"command line", doesn't the following happen?

1. My makefile sets O=/foo
2. My makefile invokes your makefile with O=/foo
3. Your makefile ignores my O=/foo because it requires O=/foo to
originate from the command line
4. KBUILD_OUTPUT never gets set to /foo and we hit the error

OTOH, if I use "file":
1. My makefile sets O=/foo
2. My makefile invokes your makefile with O=/foo
3. Your makefile accepts my O=/foo because it requires O=/foo to
originate from another makefile
4. KBUILD_OUTPUT gets set to /foo and my make succeeds

This all used to work the last time I tried it, which was sometime
during 2.6.23 development, IIRC.  Isn't the current structure going to
break just about all out-of-tree driver builds?

Jay
