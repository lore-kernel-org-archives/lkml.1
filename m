Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbZAHWry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbZAHWry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbZAHWrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:47:40 -0500
Received: from whimsy.udel.edu ([128.4.2.3]:41645 "EHLO whimsy.udel.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210AbZAHWrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:47:40 -0500
X-Greylist: delayed 1517 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 17:47:39 EST
Message-ID: <49667C97.10000@udel.edu>
Date: Thu, 08 Jan 2009 22:22:15 +0000
From: David Mills <mills@udel.edu>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.2) Gecko/20040804 Netscape/7.2 (ax)
X-Accept-Language: en-us, en
CC: linux-kernel@vger.kernel.org, ntpwg@lists.ntp.isc.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
References: <20090107.103947.1324582654.imp@bsdimp.com>	<20090107193127.0bec8ad8@lxorguk.ukuu.org.uk>	<496579C2.5050800@ntp.isc.org>	<20090107.214220.-233694826.imp@bsdimp.com>	<20090108104854.2dbc41b1@lxorguk.ukuu.org.uk> <20090108105656.6457f6cc@lxorguk.ukuu.org.uk>
In-Reply-To: <20090108105656.6457f6cc@lxorguk.ukuu.org.uk>
X-Sanitizer: This message has been sanitized!
X-Sanitizer-URL: http://mailtools.anomy.net/
X-Sanitizer-Rev: UDEL-ECECIS: Sanitizer.pm,v 1.64 2002/10/22 MIME-Version: 1.0
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

You are not correct. The kernel software clock variable is in fact 
stepped back, but the routine that actually reads the clock does not 
step the clock back unless set back more than two seconds.. Otherwise, 
the clock is strictly monotonic. That is the ad vice I gave in rfc1583 
and implemented the Digital Unix kernel because I wrote tthe code. Other 
kernelmongers might or might not have taken the advice.

As for the TAI issue discussed earlier, note that the generic NTP kernel 
supportfrom me since 1991  has TAI . However, support to read it 
requires the ntp_gettime()  syscall and nlot all kernels support it.

The recent leap was observed to work correctly in Solaris and FreeBSD. 
It worked fine with the WWV driver and the Spectracom GPS driver, but 
not the NMEA, Arbiter, Meinberg nor any of the NIST or USNO primary 
servers. It probably did work with the Canadian servers, since the 
Ottowa primary server is synchronized via my CHU audio driver. It didn't 
work onn my carefully contrived backroom servers, as they lost power 
durring the event.

See  www.eecis.udel.edu/~mills/leap.html and/or the online NTP 
documentation and/or my book.

Dave

Alan Cox wrote:

>On Thu, 8 Jan 2009 10:48:54 +0000
>Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
>  
>
>>>On FreeBSD, Solaris and Digital Unix, I'll point out, that jumping
>>>backwards is used, and has been used since at least 1994.  So saying
>>>it isn't used in the world today is flat out wrong.
>>>      
>>>
>
>[Ignore previous email, must remember not to post before waking up  ;)]
>
>You are correct - and providing gettimeofday() is being used on Linux
>rather than time() which simply appears to stall due to resolution the
>same is true.
>
>Some users do run with the "right" timezone data in non posix mode
>because they want their seconds 'sane' but that isn't the default.
>
>Alan
>
>
>_______________________________________________
>ntpwg mailing list
>ntpwg@lists.ntp.org
>https://lists.ntp.org/mailman/listinfo/ntpwg
>  
>

