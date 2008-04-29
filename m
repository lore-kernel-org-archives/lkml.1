Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYD2R1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYD2R1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbYD2RVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51569 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758661AbYD2RVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:10 -0400
Date: Tue, 29 Apr 2008 18:20:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Timur Tabi <timur@freescale.com>, Tony Breeds <tony@bakeyournoodle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
Message-ID: <20080429172057.GN5882@ZenIV.linux.org.uk>
References: <481529B6.6030802@freescale.com> <20080428015151.GW20457@bakeyournoodle.com> <481739BF.8010305@freescale.com> <20080429164535.GB18018@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429164535.GB18018@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 06:45:35PM +0200, Sam Ravnborg wrote:
> On Tue, Apr 29, 2008 at 10:07:43AM -0500, Timur Tabi wrote:
> > Tony Breeds wrote:
> > 
> > > On most linux systems echo supports c-syle escapes with "-e".  I'm
> > > guessing which ever echo you're getting dosesn't do that.
> > 
> > Yes, that is my problem.
> > 
> > > I think the best fix is to ensure you're getting bash as your shell.
> > 
> > The script starts off with this line:
> > 
> > #!/bin/sh
> > 
> > Doesn't that mean that it should be interpreted by sh and not bash?
> > 
> > > A nasty hack would be to make check-lxdialog.sh do something like:
> > > (echo ' #include CURSES_LOC';echo 'main() {}') | gcc '-DCURSES_LOC=<ncurses.h>' -DLOCALE -DKBUILD_NO_NLS -lncurses -xc - -o .lxdialog.tmp
> > 
> > This works.  Do you think if I posted a patch that makes this change, it will be
> > accepted?
> 
> Yes.

Good grief, folks...

check() {
	$cc -xc - -o $tmp 2>/dev/null <<'EOF'
#include CURSES_LOC
main() {}
EOF
	...
if you insist on feeding these two lines to gcc stdin.  Nasty hack, indeed...

<<'word'
[lines]
word

redirects stdin and feeds lines to it verbatim.  Same without quotes will
do the same, but do expansion in the text first.

It's been there since the original Bourne's shell in v7 and it's a bloody
standard way to redirect from text...
