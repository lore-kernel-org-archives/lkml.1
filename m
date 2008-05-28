Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYE1Wsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYE1Wsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYE1Wsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:48:45 -0400
Received: from mail.tmr.com ([64.65.253.246]:48975 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbYE1Wso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:48:44 -0400
Message-ID: <483DE40D.8090608@tmr.com>
Date: Wed, 28 May 2008 19:00:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?UTF-8?B?SmVucyBCw6Rja21hbg==?= <jens.backman@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>	<95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com> <20080528195752.0cdcbc6d@core>
In-Reply-To: <20080528195752.0cdcbc6d@core>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 28 May 2008 18:34:00 +0200
> "Jens Bäckman" <jens.backman@gmail.com> wrote:
> 
>> On Wed, May 28, 2008 at 10:53 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>> Results:
>>>
>>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
>>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>> Either the RAID 1 read speed must be wrong, or something is odd in the
>> Linux implementation. There's six drives that can be used for reading
>> at the same time, as they contain the very same data. 63MB/s
>> sequential looks like what you would get from a single drive.
> 
> Which is fairly typical of a cheap desktop PC where the limitation is the
> memory and PCI bridge as much as the drive.
> 
I really don't think that's any part of the issue, the same memory and 
bridge went 4-5x faster in other read cases. The truth is that the 
raid-1 performance is really bad, and it's the code causing it AFAIK. If 
you track the actual io it seems to read one drive at a time, in order, 
without overlap.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

