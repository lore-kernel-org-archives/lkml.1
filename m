Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbXAaA3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbXAaA3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXAaA3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:29:45 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57354 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbXAaA3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:29:44 -0500
Message-ID: <45BFE2F4.8080309@us.ibm.com>
Date: Tue, 30 Jan 2007 18:29:40 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       cbe-oss-dev@ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling
 Cell BE SPUs -- update
References: <45BE4ED0.5030808@us.ibm.com> <45BE4FA4.9020105@us.ibm.com> <200701300839.05144.arnd@arndb.de> <45BFBB78.7060907@us.ibm.com> <45BFCC8E.4000008@us.ibm.com> <1170200044.26655.349.camel@localhost.localdomain>
In-Reply-To: <1170200044.26655.349.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:

>>I've given this some more thought, and I'm coming to the conclusion that 
>>a pure array-based implementation for holding cached_info (getting rid 
>>of the lists) would work well for the vast majority of cases in which 
>>OProfile will be used.  Yes, it is true that the mapping of an SPU 
>>context to a phsyical spu-numbered array location cannot be guaranteed 
>>to stay valid, and that's why I discard the cached_info at that array 
>>location when the SPU task is switched out.  Yes, it would be terribly 
>>inefficient if the same SPU task gets switched back in later and we 
>>would have to recreate the cached_info.  However, I contend that 
>>OProfile users are interested in profiling one application at a time. 
>>They are not going to want to muddy the waters with multiple SPU apps 
>>running at the same time.  I can't think of any reason why someone would 
>>conscisouly choose to do that.
>>
>>Any thoughts from the general community, especially OProfile users?
> 
> 
> Well, it's my understanding that quite a few typical usage scenario
> involve different tasks running on different SPUs passing each other
> data around.
That shouldn't be a problem.  I would consider this to be "one large 
application" consisting of multiple SPU binaries running simultaneously. 
  Such a scenario can be handled with no negative performance impact 
using a simple 16 element array of cached_info objects -- as long as 
there isn't (much) SPU task switching being done.

-Maynard
> 
> Ben.
> 
> 


