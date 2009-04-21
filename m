Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZDUK0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZDUK0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZDUKZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:25:52 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:10546 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZDUKZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V/U70C3EUvBCzbmYZy+3Wpe47//8S178yV3NIf79uV/EWuYJfc+MMpAJx93Zie8s4k
         vQXzYSc2twWxrDpqiXdWxog7gURcRuuWCox81r6KC/kijJqplAoVjt4iqMIjAimqi9u/
         Ifw1vr/Ii1RzhjkCnniFRJf4IwwXtWSs4AO/E=
MIME-Version: 1.0
In-Reply-To: <20090421084519.GE12713@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-13-git-send-email-mel@csn.ul.ie>
	 <1240299982.771.48.camel@penberg-laptop>
	 <20090421084519.GE12713@csn.ul.ie>
Date: Tue, 21 Apr 2009 13:25:50 +0300
X-Google-Sender-Auth: bc1ec8914d63ab4a
Message-ID: <84144f020904210325v49b0321sfea6b7d9fc426237@mail.gmail.com>
Subject: Re: [PATCH 12/25] Remove a branch by assuming __GFP_HIGH == 
	ALLOC_HIGH
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Tue, Apr 21, 2009 at 11:45 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > @@ -1639,8 +1639,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>> >      * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
>> >      * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
>> >      */
>> > -   if (gfp_mask & __GFP_HIGH)
>> > -           alloc_flags |= ALLOC_HIGH;
>> > +   VM_BUG_ON(__GFP_HIGH != ALLOC_HIGH);
>> > +   alloc_flags |= (gfp_mask & __GFP_HIGH);
>>
>> Shouldn't you then also change ALLOC_HIGH to use __GFP_HIGH or at least
>> add a comment somewhere?
>
> That might break in weird ways if __GFP_HIGH changes in value then. I
> can add a comment though
>
> /*
>  * __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch.
>  * Check for DEBUG_VM that the assumption is still correct. It cannot be
>  * checked at compile-time due to casting
>  */
>
> ?

I'm perfectly fine with something like that.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

                                      Pekka
