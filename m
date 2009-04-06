Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbZDFVmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbZDFVmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbZDFVl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:41:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:41598 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846AbZDFVl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=n9M/bKTD2BkI5g8jO1+4LyOnlihZyYLXQY6BApFKmK+mrXhb7q05iS89aV/WHZxNlJ
         SivOQ4gullzxHwUspcyHWl560VoNEx1mCVkJ9iXGBhwhF0hfyOFMmYX/tCRFwMirzAde
         lzf0C44NXxCMF+raRYu2bCZzuy6+NQr7gvQRc=
Message-ID: <49DA7708.3040201@gmail.com>
Date: Mon, 06 Apr 2009 23:41:28 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: kernel oops with latest git v2.6.29-9516-g0221c81
References: <49DA6168.2020701@gmail.com> <200904062234.29481.a.miskiewicz@gmail.com> <49DA69DD.2090203@linux.intel.com>
In-Reply-To: <49DA69DD.2090203@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven ha scritto:
> Arkadiusz Miskiewicz wrote:
>> On Monday 06 of April 2009, Riccardo Magliocchetti wrote:
>>> Hi,
>>>
>>> i've updated the kernel to latest git and now it's oopsing.
>>>
>>> I've uploaded 3 pictures taken from a camera here:
>>>
>>> http://yfrog.com/41oops1j
>>> http://yfrog.com/bcoops2j
>>> http://yfrog.com/bcoops3j
>>
>> You hit the same thing as me:
> 
> I'm not so sure of that.
> 
> All the oopses from the URL above seem to have the "F" flag set for the 
> modules, which implies that
> the modules you're using don't match the kernel you are running. That's 
> a pretty bad deal
> in general, and more likely than not to be the cause of any weird 
> crashes you're getting...

Ok so i've started bisecting and taking care of removing the old modules 
at each step, this is what i have done for today, will continue tomorrow:

$ git bisect log
git bisect start
# bad: [0221c81b1b8eb0cbb6b30a0ced52ead32d2b4e4c] Merge branch 
'audit.b62' of 
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current
git bisect bad 0221c81b1b8eb0cbb6b30a0ced52ead32d2b4e4c
# good: [c4361bb64b81f5b81a7a08d58654493385a2f2b2] Merge branch 'master' 
of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
git bisect good c4361bb64b81f5b81a7a08d58654493385a2f2b2
# good: [6555be0a1c25576be6270bb43f1bd444df7d86f8] Staging: comedi: 
Remove mpc8260cpm_private typedef
git bisect good 6555be0a1c25576be6270bb43f1bd444df7d86f8
# good: [645dae969c3b8651c5bc7c54a1835ec03820f85f] tracing, net: fix net 
tree and tracing tree merge interaction
git bisect good 645dae969c3b8651c5bc7c54a1835ec03820f85f
# good: [7ec0a7290797f57b780f792d12f4bcc19c83aa4f] ACPI: processor: use 
.notify method instead of installing handler directly
git bisect good 7ec0a7290797f57b780f792d12f4bcc19c83aa4f

thanks,
riccardo
