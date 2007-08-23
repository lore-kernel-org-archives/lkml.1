Return-Path: <linux-kernel-owner+w=401wt.eu-S1765388AbXHWUKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765388AbXHWUKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758830AbXHWUKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:10:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771AbXHWUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:10:05 -0400
Message-ID: <46CDE981.9030506@zytor.com>
Date: Thu, 23 Aug 2007 13:09:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Avi Kivity <avi@argo.co.il>
CC: Gerald Britton <gbritton@doomcom.org>, Michael Smith <msmith@xiph.org>,
       linux-kernel@vger.kernel.org, Andy Wingo <wingo@fluendo.com>
Subject: Re: gettimeofday() jumping into the future
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com> <20070823113648.GA5405@zante.sekrit.org> <46CD85AC.7050805@argo.co.il>
In-Reply-To: <46CD85AC.7050805@argo.co.il>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Gerald Britton wrote:
>> On Thu, Aug 23, 2007 at 01:08:27PM +0200, Michael Smith wrote:
>>  
>>> Hi,
>>>
>>> We've been seeing some strange behaviour on some of our applications
>>> recently. I've tracked this down to gettimeofday() returning spurious
>>> values occasionally.
>>>
>>> Specifically, gettimeofday() will suddenly, for a single call, return
>>> a value about 4398 seconds (~1 hour 13 minutes) in the future. The
>>> following call goes back to a normal value.
>>>     
>>
>> I have seen this as well (on a 2.6.20.4 kernel).  The value returned was
>> always identical each time the glitch occured (just a little over 4398
>> seconds).  I saw it watching packet receive timestamps and on the
>> system in
>> question, it would generally hit this problem around once a minute.  When
>> moving forward to a 2.6.21 kernel, the problem seemed to go away (also
>> back
>> to 2.6.17, unfortunately I didn't have any sample points inbetween).
>> I didn't have free time to spend bisecting attempting to find when the
>> behavior started or stopped.
> 
> That value, in nanoseconds, is 0x3fffd3a4c00.  The next second is
> 0x40038d51600.  Is the wraparound at (0x400 << 32) significant?
> 

This would be consistent with an off-by-2^32 error.  In particular, if
either a CPU bug or a code bug could at some point produce 0x400fxxxxxxx
in between then that would produce exactly the observed characteristics.

	-hpa

