Return-Path: <linux-kernel-owner+w=401wt.eu-S1030573AbXAZQIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbXAZQIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030590AbXAZQIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:08:43 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:38203 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030573AbXAZQIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:08:43 -0500
Date: Fri, 26 Jan 2007 11:08:42 -0500
To: Paul Fulghum <paulkf@microgate.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
Message-ID: <20070126160842.GM7582@csclub.uwaterloo.ca>
References: <20070124204009.GA7584@csclub.uwaterloo.ca> <45B7CDB5.7020909@microgate.com> <20070125151639.GH7582@csclub.uwaterloo.ca> <20070126142041.GD7584@csclub.uwaterloo.ca> <45BA1556.8080808@microgate.com> <20070126145608.GK7582@csclub.uwaterloo.ca> <45BA190C.5040300@microgate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA190C.5040300@microgate.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 09:06:52AM -0600, Paul Fulghum wrote:
> ioctl(TIOCSETD/TIOCGETD) sets/returns an integer identifier
> that can be compared agains the N_XXX macros. If you are
> not explicitly setting this then is is probably the default N_TTY.

Yes it is N_TTY (value 0).  I never set it.

> Also at the application level, look at tcsetattr() for setting
> the termios features. Look specifically at the c_cc[VTIME] and c_cc[VMIN]
> members of the termios structure. These settings control how
> much data must be available before returning data to a read().
> Try VTIME=0 and VMIN=1.
> 
> Since your 'missing' data is always on the tail end, maybe
> VMIN is set to 64 or something.

OK, the tty settings according to stty that I am using are:
# stty -F /dev/ttyn0 -a
speed 230400 baud; rows 0; columns 0; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>; eol2 = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R;
werase = ^W; lnext = ^V; flush = ^O; min = 1; time = 0;
-parenb -parodd cs8 hupcl -cstopb cread clocal -crtscts
-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl -ixon -ixoff -iuclc -ixany -imaxbel
-opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
-isig -icanon iexten -echo -echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke

So min and time seems good.  I am not explicitly setting those in my
test program (unless one of the other settings implies it).  I will add
it explicitly just in case too.

--
Len Sorensen
