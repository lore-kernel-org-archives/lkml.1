Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbZFZXaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbZFZXaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZFZX3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:29:51 -0400
Received: from mail.anarazel.de ([217.115.131.40]:55732 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbZFZX3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:29:50 -0400
Message-ID: <4A4559ED.2060307@anarazel.de>
Date: Sat, 27 Jun 2009 01:29:49 +0200
From: Andres Freund <andres@anarazel.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090625 Shredder/3.0b3pre
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: [BUG] GM45 blanks shortly after boot in 2.6.30-git
References: <4A43359F.3030208@anarazel.de> <20090625094152.179740c0@jbarnes-g45>
In-Reply-To: <20090625094152.179740c0@jbarnes-g45>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2009 06:41 PM, Jesse Barnes wrote:
> On Thu, 25 Jun 2009 10:30:23 +0200
> Andres Freund<andres@anarazel.de>  wrote:
>
>> Hi,
>>
>> Somewhere between:
>> 03347e2592078a90df818670fddf97a33eec70fb (2.6.30 + 5415 commits)
>> and
>> c82e6d450fda56cb2d4f68534173d3cd11b32f9f (2.6.30 + 8722 commits)
>> my Laptop (Lenovo T500) with an Intel GM45 graphics card blanks
>> display during boot (before starting with initramfs) , stops
>> responding to anything (i.e. no caps-lock light) and shows no further
>> activity (i.e. no hdd activity).
>>
>> Before the blank I did not see any sign of a backtrace or similar,
>> but its hard to say there wasn't any. Unfortunately atm I don't have
>> another computer nearby, so I could not get a network console output
>> yet.
>
> So the i915 driver probably loaded and turned off your display, either
> by programming a bad mode or misdetecting something else...
>
>> Any other information needed?
>
> Can you try loading the drm module with debug=1?  That should give us
> some more info about what's going on.
Is the information from the failed or from the working boot interesting?

> A bisect would help too of course...
I am now in the middle of bisecting (currently at d888a4c) and 
interestingly the original problem does not occur at that commit, but 
the modes of my external monitor get misdiagnosed (no 1680x1050 
resolution anymore) - the internal one works fine.
That happended somewhere between 0a4de47 and d888a4c. I will skip this 
issue for now and keep bisecting the old issue.

Andres
