Return-Path: <linux-kernel-owner+w=401wt.eu-S1764896AbYD1BfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764896AbYD1BfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 21:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYD1Bek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 21:34:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38687 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbYD1Bei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 21:34:38 -0400
Message-ID: <481529AB.7050304@tabi.org>
Date: Sun, 27 Apr 2008 20:34:35 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: cross-compiling on OS X, make menuconfig fails
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to cross-compile a PowerPC kernel from an Intel OS X system. 
  I've almost got it working, except "make menuconfig" dies.  It says 
I'm missing ncurses:

  *** Unable to find the ncurses libraries or the
  *** required header files.
  *** 'make menuconfig' requires the ncurses libraries.

However, I do not think that ncurses is the real problem, since I do 
have ncurses installed.  I think the real problem is that the 
check-lxdialog.sh is trying to execute this code:

echo -e ' #include CURSES_LOC \n main() {}' | gcc 
'-DCURSES_LOC=<ncurses.h>' -DLOCALE -DKBUILD_NO_NLS -lncurses -xc - -o 
.lxdialog.tmp

And the compiler is failing with this output:

<stdin>:1: error: syntax error before ‘-’ token
<stdin>:1: error: stray ‘#’ in program

So something strange is going on.  Has anyone been able to cross-compile 
from an Intel Mac running OS X?
