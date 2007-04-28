Return-Path: <linux-kernel-owner+w=401wt.eu-S1161775AbXD1I7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161775AbXD1I7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161778AbXD1I7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:59:04 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:38195 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161775AbXD1I7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:59:01 -0400
Message-ID: <46330CD1.8040306@simon.arlott.org.uk>
Date: Sat, 28 Apr 2007 09:58:57 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH (rev 2)] cxacru: Cleanup sysfs attribute code
References: <462E730F.3090401@simon.arlott.org.uk>	<200704250919.50382.duncan.sands@math.u-psud.fr>	<11882.simon.1177499883@5ec7c279.invalid>	<462FA0D0.9040901@simon.arlott.org.uk> <20070428005028.54f1b621.akpm@linux-foundation.org>
In-Reply-To: <20070428005028.54f1b621.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/04/07 08:50, Andrew Morton wrote:
> On Wed, 25 Apr 2007 19:41:20 +0100 Simon Arlott <simon@fire.lp0.eu> wrote:
>> This changes the format of unknown status values to be less verbose and 
>> uses an array instead of several different snprintf calls. Since only 
>> enum values are assigned to it, poll_state is changed from int to enum. 
>> Use abs() for dB values instead of two almost identical return lines.
>> ...
>> +	static char *str[] = { "no", "yes" };
>> +	if (unlikely(value >= ARRAY_SIZE(str)))
>> +		return snprintf(buf, PAGE_SIZE, "%u\n", value);
>> +	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
> 
> Should a bool be displayed as "true" or "false"?

The only attribute that uses this is line_startable... I suppose 
it could return true/false - I just happened to use yes/no.

>> +		return snprintf(buf, PAGE_SIZE, "%u\n", value);
> 
> To be completely pedantic: we shouldn't be printing u32's with %u.  Because
> %u assumes that u32 is implemented as unsigned int.  Only it's an opaque
> type and we don't know what actual C type the architecture chose to use.
> 
> It happens to work OK on all architectures and I expect it always will, so
> no change is needed, but there you have it.

Ok.

> u64's and %llu _are_ incompatible on some architectures and I get to fix
> that about 1000000 times.

-- 
Simon Arlott
