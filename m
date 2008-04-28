Return-Path: <linux-kernel-owner+w=401wt.eu-S1765336AbYD1BwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765336AbYD1BwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 21:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYD1Bvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 21:51:54 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:48040 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbYD1Bvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 21:51:53 -0400
Date: Mon, 28 Apr 2008 11:51:51 +1000
To: timur@freescale.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
Message-ID: <20080428015151.GW20457@bakeyournoodle.com>
References: <481529B6.6030802@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481529B6.6030802@freescale.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 08:34:46PM -0500, timur@freescale.com wrote:
> I'm trying to cross-compile a PowerPC kernel from an Intel OS X system. 

<snip>
 
> However, I do not think that ncurses is the real problem, since I do 
> have ncurses installed.  I think the real problem is that the 
> check-lxdialog.sh is trying to execute this code:
> 
> echo -e ' #include CURSES_LOC \n main() {}' | gcc 
> '-DCURSES_LOC=<ncurses.h>' -DLOCALE -DKBUILD_NO_NLS -lncurses -xc - -o 
> .lxdialog.tmp
> 
> And the compiler is failing with this output:
> 
> <stdin>:1: error: syntax error before ‘-’ token
> <stdin>:1: error: stray ‘#’ in program

On most linux systems echo supports c-syle escapes with "-e".  I'm
guessing which ever echo you're getting dosesn't do that.

I think the best fix is to ensure you're getting bash as your shell.

A nasty hack would be to make check-lxdialog.sh do something like:
(echo ' #include CURSES_LOC';echo 'main() {}') | gcc '-DCURSES_LOC=<ncurses.h>' -DLOCALE -DKBUILD_NO_NLS -lncurses -xc - -o .lxdialog.tmp

But you'll likley find other palces it breaks.

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

