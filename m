Return-Path: <linux-kernel-owner+w=401wt.eu-S1767285AbXECAS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767285AbXECAS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 20:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767286AbXECAS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 20:18:26 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:21232 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767285AbXECASZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 20:18:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=kusoicdDQb6cxKiDfRm3pmcoG1mvHZlDvCEbkTzdoi90gxOGp2Yt+rXso3fVkI/rXFZag4IUwJUHwm+4I3QDQqHEcDMiy998ZMpuO/05+nHHYUtc7U08CKdvo9XXCNU1MfucZOwvVP9tuDNqKlsQ6HRH/2bEuM62rnEP8aIl9T0=  ;
X-YMail-OSG: Y9H_5usVM1lB75xMs1EPJCoVvB2yJ04zMXyjnO1fqOZa2ImuJpFo06ORu5AOGqPcZKyKQ73QHQ--
Message-ID: <46392A3C.30606@yahoo.com.au>
Date: Thu, 03 May 2007 10:18:04 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: mm-more-rmap-checking
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <Pine.LNX.4.64.0705011458060.16979@blonde.wat.veritas.com> <4637EC95.2010501@yahoo.com.au> <Pine.LNX.4.64.0705021355390.16517@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705021355390.16517@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 2 May 2007, Nick Piggin wrote:
> 
>>Yes, but IIRC I put that in because there was another check in
>>SLES9 that I actually couldn't put in, but used this one instead
>>because it also caught the bug we saw.
>>... 
>>This was actually a rare corruption that is also in 2.6.21, and
>>as few rmap callsites as we have, it was never noticed until the
>>SLES9 bug check was triggered.
> 
> 
> You are being very mysterious.  Please describe this bug (privately
> if you think it's exploitable), and let's work on the patch to fix it,
> rather than this "debug" patch.

It is exec-fix-remove_arg_zero.patch in Andrew's tree, it's exploitable
in that it leaks memory, but it could also release corrupted pagetables
into quicklists on those architectures that have them...

Anyway, it quite likely would have gone unfixed for several more years
if we didn't have the bug triggers in. Now you could argue that my
patch obviously fixes all bugs in there (but I wouldn't :)), and being
most complex of the few callsites, _now_ we can avoid the bug checks.
However I'd prefer to keep them at least under CONFIG_DEBUG_VM.


>>Hmm, I didn't notice the do_swap_page change, rather just derived
>>its safety by looking at the current state of the code (which I
>>guess must have been post-do_swap_page change)...
> 
> 
> Your addition of page_add_new_anon_rmap clarified the situation too.
> 
> 
>>Do you have a pointer to the patch, for my interest?
> 
> 
> The patch which changed do_swap_page?
> 
> commit c475a8ab625d567eacf5e30ec35d6d8704558062
> Author: Hugh Dickins <hugh@veritas.com>
> Date:   Tue Jun 21 17:15:12 2005 -0700
> [PATCH] can_share_swap_page: use page_mapcount


Yeah, this one, thanks. I'm just interested.


> Or my intended PG_swapcache to PAGE_MAPPING_SWAP patch,
> which does assume PageLocked in page_add_anon_rmap?
> Yes, I can send you its current unsplit state if you like
> (but have higher priorities before splitting and commenting
> it for posting).

I would like to see that too, but when you are ready :)

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
