Return-Path: <linux-kernel-owner+w=401wt.eu-S1422957AbXCOQvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422957AbXCOQvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422954AbXCOQvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:51:14 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:44422 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030650AbXCOQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:51:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=DPEoaLV2GZa7heg1Q4OsjIe6mji9JDwJWMQNDi93+K2DIosKUQiwTWwusXBkZ6GSOiQgsyOi5UaSGOsa4n3zxjLJsGVk1fwSEW/vH1SHZPFdQXbS+U5RI83hlLeisqfXON0GisPKeX1nLReCJYk9t97CrPbV16mg/HyypFFSbog=  ;
X-YMail-OSG: 31nYL4cVM1kBQ8SpiOKyHJCOF0fR97.Wrw26vXv_ixuExsbEtpFj6M3zqQMIY7xCpeNlmaJFxgm0ZS6fxkGTCkHHGfG1TzVuBlVQR.WUD70JvFUs0sxOtLsSJ56oGNnt3LGRWmrB7b4CUdsOnEdEsPSEYeWUe_pnQgsdeE9eafvtxqz0Vd2Z
Message-ID: <45F97971.7080000@yahoo.com.au>
Date: Fri, 16 Mar 2007 03:50:57 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <1173879210.31159.30.camel@localhost.localdomain> <20070314134112.GB13486@elte.hu> <Pine.LNX.4.64.0703140945530.9690@woody.linux-foundation.org> <20070314181508.GB12994@elte.hu>
In-Reply-To: <20070314181508.GB12994@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> 
>>>symbolic links perhaps? In that case i'd also introduce a common 
>>>naming scheme: x86_early_printk.c - to make sure we know it right 
>>>away that those files are bi-arch.
>>
>>Hey, I know! This is a radical idea, but what if we put the name at 
>>the head of the file, and called it
>>
>>	arch/x86/kernel/early_printk.c
>>
>>instead? Then we could teach each of i386 and x86-64 to include it 
>>from that area, and we could put other shared files under the same 
>>directory hierarchy so that it would be easy to see which ones are 
>>shared?
> 
> 
> that is nice too, but it has some disadvantages as well in practice. For 
> example i often want to see 'everything' that belongs to an arch in just 
> one subdirectory. That way one can grep it for example, instead of 
> having to grep two separate places. Symlinks would be fine for that, but 
> an explicit split not really i think - unless we can get some really 
> significant chunk of code into that hierarchy, so that it makes 
> functional /sense/ to look at it in isolation.
> 
> with the prefix suggestion we can keep these 'shared' files merged in a 
> single, main functional tree (x86_64), but still have them marked in the 
> VFS as being shared. But ... either way is fine to me - no strong 
> feelings, really.

You could do both. Have the x86 directory that Linus suggests for shared
files, then have the build system generate the symlinks for you.

Could have arch/x86_64/kernel/common arch/x86_64/mm/common etc. symlinks.
that point to arch/x86/kernel, arch/x86/mm etc.

This way you know exactly which files are shared and which are not, which
is basically impossible without a grep currently. You also get to do a
single grep of all arch code. Best of both worlds? Or do I miss something?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
