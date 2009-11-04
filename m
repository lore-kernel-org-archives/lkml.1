Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZKDM5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZKDM5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZKDM5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:57:53 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59533 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbZKDM5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LdUTeTOwGMUwE1IAq1Jwz3Ov/hSvkkxwX5hBE5Q8pBnvI3xqB6M/rO3zICRR+sCA01
         FXRL/CCBM1fczWb39uVxuhEk7L7iukLYH+OK7/49soHtSXv3IWbzN7Trq7yewt6jUdBz
         eIWCHLE5df+2jDjbpOBlEIkK/lZTb5uwAGniI=
Message-ID: <4AF17DED.7080808@gmail.com>
Date: Wed, 04 Nov 2009 13:13:17 +0000
From: Dave Korn <dave.korn.cygwin@googlemail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0,  oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com> <20091103222432.4a94bd8f.akpm@linux-foundation.org>
In-Reply-To: <20091103222432.4a94bd8f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 2 Nov 2009 13:29:29 -0800 Justin Mattock <justinmattock@gmail.com> wrote:
> 
>> Hello,
>> I'm not sure how to handle this,
>> while compiling firefox-3.6b1.source
>> I get this with the default compiling options,
>> as well as custom:
>>
>> ...
>>
>> active_anon:2360492kB inactive_anon:590196kB active_file:84kB
> 
> 2.8GB of anonymous memory
> 
>> [  532.942508] Free swap  = 0kB
>> [  532.942510] Total swap = 431632kB
> 
> 430MB of swap, all used up.
> 
> That's a genuine OOM.  Something (presumably cc1plus) has consumed
> waaaay too much memory, quite possibly leaked it.
> 
> It would help if the oom-killer were to print some information about
> the oom-killed process's memory footprint.

  I would think that the quickest way to proceed would be to re-run the
failing compile command under gdb at the command-line and see what it's doing
when the oom killer signals it, wouldn't it?  Or turn up the swap until it
doesn't get killed and see what info can be gleaned from the cc1(plus?)
-fmem-report output.

    cheers,
      DaveK

