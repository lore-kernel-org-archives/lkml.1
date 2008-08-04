Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbYHDTnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbYHDTnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762530AbYHDTnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:43:19 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:24687 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762509AbYHDTnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:43:18 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=jo_vsWNFDWsYHX0XXdoA:9 a=TjeBqovgBLviA24pvNCLQuDfafUA:4 a=LMXrpmZLf_4A:10 a=gOtm7ChVIs8A:10
Message-ID: <48975BD3.6040709@shaw.ca>
Date: Mon, 04 Aug 2008 13:43:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Dushan Tcholich <dusanc@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ksoftirqd high cpu load on kernels 2.6.24 to 2.6.27-rc1-mm1
References: <fa.wTMiBcGRgw2fBtdHwtX7y0lkc8s@ifi.uio.no>
In-Reply-To: <fa.wTMiBcGRgw2fBtdHwtX7y0lkc8s@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dushan Tcholich wrote:
> Hello
> 
> This is my first bugreport on LKML so please be patient :)
> 
> top always shows me that ksoftirqd usualy gets around 8%CPU, it
> changes between 6 and 10%.
> It's sometimes ksoftirqd/0 sometimes /1, differs on the reboot but
> doesn't change during work.
> I noticed it because it had very high time+, 500hours or so.
> I reproduced these problems with kernels 2.6.24 .25 and .27-rc1-mm1. I
> don't remember that this happened during .22 and .23 kernels, but I
> can check again if it's necessary.
> Timer freq is 1000Hz
> 
> What I tried without changes with help from ##kernel:
> 1. built kernel without kvm;
> 2. disconnected all usb hw except mouse;
> 3. run glxgears which consumed 98% CPU and ksoftirqd  2%;
> 4. Tried to stress disk subsystem by copying a lot of small files on
> the same partition:
> time cp -R /usr/portage/* /tmp/1
> real 2m17.530s
> user 0m0.764s
> sys 0m18.596s
> 
> it was 127507 items 1.5GB, but just pdflush jumped to 14% from time to time;
> 5. disabled serial port in BIOS because my UPS was connected to it,
> and I suspected that it was maybe polling too much;
> 6. disconnected eth cable
> 7. tried googling but all I found is that some people had similar
> problem. Some TV cards were the culprit but I don't have that HW.
> 
> If you need any more data please cc me as I'm not subscribed

It would be useful to try running oprofile on an otherwise idle system 
and see where it reports the CPU time is being used..
