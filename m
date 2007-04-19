Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXDSO0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXDSO0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXDSO0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:26:42 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:52608 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXDSO0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:26:41 -0400
Date: Thu, 19 Apr 2007 08:26:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: problem with <asm/semaphore.h>
In-reply-to: <1176961482.904618.250700@e65g2000hsc.googlegroups.com>
To: liangbowen <liangbowen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <46277C06.4020602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1176885218.597268.304370@l77g2000hsb.googlegroups.com>
 <fa.fBTtgscoj66JCf4bIm8v290vCRo@ifi.uio.no>
 <fa.w5cKcLCYzl2eiKiQW21MMlLALWM@ifi.uio.no>
 <1176961482.904618.250700@e65g2000hsc.googlegroups.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

liangbowen wrote:
>> You're trying to use a kernel data structure in a user-space program.
>> Don't. The definitions in that header are inside #ifdef __KERNEL__ and
>> so the provided userspace headers remove that part.
> 
> someone've said the exact same thing, and he said that I can add the -
> D__KERNEL__ to the compilation options,
> but I can't see any #ifdef __KERNEL__ macro in that header(<asm/
> semaphore.h>).
> Is my header differ from yours?
> 

It's because the userspace headers have been processed with unifdef to 
remove any sections which are inside #ifdef __KERNEL__, since userspace 
apps are not supposed to see those sections.

I'm not sure why you want to use a semaphore in a userspace program. 
Even if you can get it to compile, they definitely won't function 
properly. Aside from the legal issues (using internal kernel code like 
that would make your program a derived work of the kernel and thus 
covered under the GPL).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

