Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbYERCQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbYERCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 22:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYERCQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 22:16:47 -0400
Received: from saeurebad.de ([85.214.36.134]:36326 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbYERCQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 22:16:46 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Alan Cox <alan@redhat.com>
Subject: bug in `tty: BKL pushdown'?
CC: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 18 May 2008 04:16:23 +0200
Message-ID: <87wslsuzk8.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

git-bisect thinks that 04f378b198da233ca0aca341b113dc6579d46123 broke my
screen setup on the console in the following way:

I run ncurses applications like less and emacs in a screen session.

Since the above mentioned commit, a detach from screen followed by a
reattach (screen -r or by unlocking the screen session after lock),
these programs behave weird.  Emacs does display mode-line updates in
the next line each time which makes the screen scroll off.  This
behaviour is with vga=normal.

On vga=791, the breakage _toggles_ between detach-reattach cycles.
I.e. emacs breaks after the first detach-reattach and works properly
again after the second one.

I have yet to test a current kernel version with this patch reverted
because I am too sleepy right now to solve the conflicts.

If you need further information to debug this, please let me know.

	Hannes
