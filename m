Return-Path: <linux-kernel-owner+w=401wt.eu-S1762935AbXHWNDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935AbXHWNDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbXHWNDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:03:43 -0400
Received: from il.qumranet.com ([82.166.9.18]:35510 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbXHWNDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:03:42 -0400
Message-ID: <46CD85AC.7050805@argo.co.il>
Date: Thu, 23 Aug 2007 16:03:40 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Gerald Britton <gbritton@doomcom.org>
CC: Michael Smith <msmith@xiph.org>, linux-kernel@vger.kernel.org,
       Andy Wingo <wingo@fluendo.com>
Subject: Re: gettimeofday() jumping into the future
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com> <20070823113648.GA5405@zante.sekrit.org>
In-Reply-To: <20070823113648.GA5405@zante.sekrit.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerald Britton wrote:
> On Thu, Aug 23, 2007 at 01:08:27PM +0200, Michael Smith wrote:
>   
>> Hi,
>>
>> We've been seeing some strange behaviour on some of our applications
>> recently. I've tracked this down to gettimeofday() returning spurious
>> values occasionally.
>>
>> Specifically, gettimeofday() will suddenly, for a single call, return
>> a value about 4398 seconds (~1 hour 13 minutes) in the future. The
>> following call goes back to a normal value.
>>     
>
> I have seen this as well (on a 2.6.20.4 kernel).  The value returned was
> always identical each time the glitch occured (just a little over 4398
> seconds).  I saw it watching packet receive timestamps and on the system in
> question, it would generally hit this problem around once a minute.  When
> moving forward to a 2.6.21 kernel, the problem seemed to go away (also back
> to 2.6.17, unfortunately I didn't have any sample points inbetween).
> I didn't have free time to spend bisecting attempting to find when the
> behavior started or stopped.
>
>   

That value, in nanoseconds, is 0x3fffd3a4c00.  The next second is 
0x40038d51600.  Is the wraparound at (0x400 << 32) significant?

-- 
error compiling committee.c: too many arguments to function

