Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZCOWbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZCOWbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 18:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZCOWbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 18:31:23 -0400
Received: from carmd-sa01.sierrawireless.com ([208.81.121.45]:44083 "EHLO
	carmd-sa01.sierrawireless.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182AbZCOWbW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 18:31:22 -0400
X-ASG-Debug-ID: 1237156277-74af00060000-xx1T2L
X-Barracuda-URL: http://carmd-sa01.sierrawireless.com:80/cgi-bin/mark.cgi
From: Rory Filer <rfiler@SierraWireless.com>
To: Ralf Nyren <ralf@nyren.net>, Stephen Clark <sclark46@earthlink.net>
CC: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Lloyd <klloyd@SierraWireless.com>
Date: Sun, 15 Mar 2009 15:30:54 -0700
X-ASG-Orig-Subj: RE: Sierra Wireless (MC8780) HSDPA speed issue
Subject: RE: Sierra Wireless (MC8780) HSDPA speed issue
Thread-Topic: Sierra Wireless (MC8780) HSDPA speed issue
Thread-Index: AcmlqizP4ls27VNiTPusGVVi4vNoCAAEq6Hw
Message-ID: <8F90F944E50427428C60E12A34A309D21C401BAA8D@carmd-exchmb01.sierrawireless.local>
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se>
 <20090314040322.GB3417@kroah.com>
 <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se>
 <20090314203256.GA7487@kroah.com> <49BC5A90.7070004@earthlink.net>
 <alpine.DEB.1.10.0903152040030.5825@fujje.iml.umu.se>
In-Reply-To: <alpine.DEB.1.10.0903152040030.5825@fujje.iml.umu.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[10.0.6.5]
X-Barracuda-Start-Time: 1237156277
X-Barracuda-Encrypted: RC4-MD5
X-Barracuda-Virus-Scanned: by CARMD-SA01 at sierrawireless.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf

Using the driver we sent you on a call-box (i.e. with a "perfect" simulated network connection) on Ubuntu 8.04 we were seeing ~4 Mbps on the downlink. So I would rule out any problem with the driver and conclude it must be something in either PPP/Linux or in the modem. In order to rule out the modem, I've got a question into one of our UMTS engineers and will send you a reply when we get the answer. 

We did play around a little with 2.4 kernels of Linux and discovered there is a buffer in PPP_ASYNC.C which, when its size is increased, doubled the throughput. If you are savvy enough with Linux, you might want to try playing with that. We stopped short of any thorough testing of changing this array size, but were pleased with the result. If I recall properly, the size of this array is (was, in 2.4) 256 bytes. Doubling it gave an immediate improvement. We were guessing that the small size of this buffer was fine in the "old days" when modems peaked at ~56 kbps. Even 8 years ago that was the fastest you could go with a GPRS product, now our new HSPA+ products yields 21 Mbps on Telstra's network! Quite a difference.

I'll pass along any reply I get from our UMTS engineer. 

Regards

Rory  Filer

-----Original Message-----
From: Ralf Nyren [mailto:ralf@nyren.net] 
Sent: Sunday, March 15, 2009 1:11 PM
To: Stephen Clark
Cc: Greg KH; linux-kernel@vger.kernel.org; Kevin Lloyd; Rory Filer
Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue

On Sat, 14 Mar 2009, Stephen Clark wrote:
>
> Yes, it would be interesting to know how you determined the download speed?
>

Not very scientific but I first turned off all network apps and verified there
were no network traffic (eg tcpdump). Then I just downloaded a 10MB file of
random data a couple of times and took note of the average speed. Of course
average is not same as peek but hope it is good enough for a real world test.

Just to make sure I repeated the tests and the download speed in Linux was
slightly above 100KB/s average for the handful of download tests performed.
Downloading the same file in Windows a couple of times resulted in a download
average of 250-350KB/s, got different speeds for each test but this is likely
due to other UEs in the cell.

So Linux was at least 2.5 times slower in the download tests so somewhere
there has to be a problem.

I'm using pppd from Debian Lenny and just the standard set of AT commands.

Please let me know if you have any other suggestions for things to try.

Best regards, Ralf


