Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZIOPvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZIOPvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZIOPvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:51:03 -0400
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:15968 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZIOPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:51:01 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 11:51:01 EDT
Message-ID: <4AAFB458.3080406@caviumnetworks.com>
Date: Tue, 15 Sep 2009 08:35:52 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Brian Gerst <brgerst@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 11/11] Use unreachable() in asm-generic/bug.h for  !CONFIG_BUG
 case.
References: <4AAEBAC2.1050905@caviumnetworks.com>  <1252965340-31735-11-git-send-email-ddaney@caviumnetworks.com> <73c1f2160909141612i32f46361q7430cecf0b68d07b@mail.gmail.com> <4AAED18E.7030903@caviumnetworks.com> <alpine.LFD.2.01.0909141637250.4950@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909141637250.4950@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Sep 2009 15:35:54.0932 (UTC) FILETIME=[36C39F40:01CA361A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 14 Sep 2009, David Daney wrote:
>> The existing code just falls through to whatever happens to follow the BUG().
> 
> Brian was talking BUG_ON().
> 
> And the existing !CONFIG_BUG BUG_ON() is actually set up so that gcc will 
> just optimize it away entirely (yet give the same compile-time warnings as 
> the "real" BUG_ON() does).
> 
> Changing it to "if (cond) unreachable()" is likely to generate _more_ 
> code, which is against the whole point of wanting to disable CONFIG_BUG.
> 

Yes, you are correct.  I said the same thing in the log message for the 
patch.

Really it may be too early for this patch to be appropriate for your 
tree.  GCC-4.5 will probably not be released for several more months, 
and it will be several years before a GCC with __builtin_unreachable() 
is being used by the majority of people compiling kernels.

Ingo had suggested the approach of this patch as a way of eliminating 
many warnings when using !CONFIG_BUG.  I think it clearly makes sense 
for compilers that support __builtin_unreachable(), but clearly it is 
not an unquestionable win if we end up generating larger code.

With this particular patch, I don't really care if you merge it or not. 
  Perhaps I shouldn't have made it part of the set.

The rest of the set I think would make sense for 2.6.32 or 2.6.33.

David Daney
