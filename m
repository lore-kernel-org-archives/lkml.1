Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYFSFRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYFSFRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYFSFRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:17:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYFSFRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:17:43 -0400
Date: Thu, 19 Jun 2008 01:17:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
In-Reply-To: <20080618.205948.107681537.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806190041080.31418@engineering.redhat.com>
References: <Pine.LNX.4.64.0806171954060.2560@engineering.redhat.com>
 <20080617.210159.141238856.davem@davemloft.net>
 <Pine.LNX.4.64.0806182318170.27388@engineering.redhat.com>
 <20080618.205948.107681537.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Wed, 18 Jun 2008 23:24:20 -0400 (EDT)
>
>> BTW. what's the purpose of having 192-byte stack frame? There are 16
>> 8-byte registers being saved per function call, so 128-byte frame should
>> be sufficient, shoudn't? The ABI specifies that some additional entries
>> must be present even if unused, but I don't see reason for them. Would
>> something bad happen if GCC started to generate 128-byte stacks?
>
> The callee can pop the arguments into the area past the
> register window.

I see ... the callee writes arguments into caller's stack frame, if it has 
variable number of arguments. That it misdesign, the callee should write 
registers arguments into it's own frame like on AMD64 (then this space 
would be allocated only if needed).
But nothing can be done with it since ABI was specified :-(

Mikulas

> So you have the 128 byte register window save area, 6
> slots for incoming arguments, which gives us 176 bytes.
> The rest is for some miscellaneous stack frame state,
> which I don't remember the details of at the moment.
> I'd have to read the sparc backend of gcc to remember.
>
