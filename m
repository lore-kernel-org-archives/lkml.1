Return-Path: <linux-kernel-owner+w=401wt.eu-S936449AbXG0GTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936449AbXG0GTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 02:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760503AbXG0GSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 02:18:53 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:54846 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685AbXG0GSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 02:18:52 -0400
Message-ID: <46A98DFE.3050304@howardsilvan.com>
Date: Thu, 26 Jul 2007 23:17:34 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>,
       linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <46A7FE6A.4030309@howardsilvan.com>	<20070726123420.GA14163@informatik.uni-freiburg.de>	<46A8CB96.1010501@howardsilvan.com> <20070726174150.4ffcabd4@the-village.bc.nu>
In-Reply-To: <20070726174150.4ffcabd4@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>The manufacturer is using a scope to look for RTS and they're not seeing 
>>it, either.  I just use my eyes to look at the LED, but I can see the 
>>CTS, DTR, DCD, RD, and TD lights blink, flicker, or dim... (and TD, RD, 
>>and CTS tend to go on and off rather quickly).
>>    
>>
>
>And you have
>
>1.	The port set up correctly for flow control options in the
>kernel ?
>  
>

I suppose that you mean that the application has properly set up the 
port using termios/tcsetattr/ioctl and the like... rather than if the 
kernel build/config options were set to permit flow control (I know of 
no relevant flow-control-enabling kernel build options).  Using hardware 
flow control this is what stty tells me about the port set up done by 
the application:

# stty -F /dev/ttyS1 -a
speed 115200 baud; rows 0; columns 0; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>; 
eol2 = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R; werase = 
^W; lnext = ^V; flush = ^O;
min = 1; time = 0;
-parenb -parodd cs8 -hupcl -cstopb cread clocal crtscts
-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl 
-ixon -ixoff -iuclc -ixany -imaxbel
-opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 
bs0 vt0 ff0
-isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop 
-echoprt -echoctl -echoke
#

Using software flow control this is what stty tells me about the port 
set up done by the application:

# stty -F /dev/ttyS1 -a
speed 115200 baud; rows 0; columns 0; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>; 
eol2 = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R; werase = 
^W; lnext = ^V; flush = ^O;
min = 1; time = 0;
-parenb -parodd cs8 -hupcl -cstopb cread clocal -crtscts
-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl ixon 
ixoff -iuclc -ixany -imaxbel
-opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 
bs0 vt0 ff0
-isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop 
-echoprt -echoctl -echoke
#

They seem correct to me, but I am certainly willing to be wrong.

>2.	Verified that the board vendor remembered to wire it ?
>

I don't know how to verify directly that the board manufacturer wired 
the serial port correctly.  I've tested this on two different 
motherboards made several years apart (but, yes, both were made by the 
same manufacturer).  However, when using RedHat 6.0 (kernel 2.2.5) I 
have no problems with data corruption occurring in the data coming from 
the DCE.  So that tells me that *something* was working before that 
isn't working now... and I'm trying to determine what the difference 
is... whether it be a problem in modern kernels or whether it be 
something that the application (HylaFAX) is not doing to accomodate 
whatever changes occurred in modern kernels.

A quick google on "input overrun(s)" may lend some credence (although, 
certainly this is not in any way conclusive) that I'm not the only one 
who may be seeking a solution on this matter.

  http://www.google.com/search?hl=en&q=%2B%22input+overrun%28s%29%22

Thanks,

Lee.

