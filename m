Return-Path: <linux-kernel-owner+w=401wt.eu-S1763672AbYF3StS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763672AbYF3StS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbYF3StG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:49:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbYF3StD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:49:03 -0400
Message-ID: <48692A76.70304@redhat.com>
Date: Mon, 30 Jun 2008 15:48:22 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 25/39] merge common parts of uaccess.
References: <1214602486-17080-17-git-send-email-gcosta@redhat.com> <1214602486-17080-18-git-send-email-gcosta@redhat.com> <1214602486-17080-19-git-send-email-gcosta@redhat.com> <1214602486-17080-20-git-send-email-gcosta@redhat.com> <1214602486-17080-21-git-send-email-gcosta@redhat.com> <1214602486-17080-22-git-send-email-gcosta@redhat.com> <1214602486-17080-23-git-send-email-gcosta@redhat.com> <1214602486-17080-24-git-send-email-gcosta@redhat.com> <1214602486-17080-25-git-send-email-gcosta@redhat.com> <1214602486-17080-26-git-send-email-gcosta@redhat.com> <20080630063030.GA31336@elte.hu>
In-Reply-To: <20080630063030.GA31336@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Glauber Costa <gcosta@redhat.com> wrote:
> 
>> common parts of uaccess_32.h and uaccess_64.h
>> are put in uaccess.h.
> 
> -tip testing found that it causes this build failure:
> 
>   fs/binfmt_aout.c: Assembler messages:
>   fs/binfmt_aout.c:152: Error: suffix or operands invalid for `cmp'
> 
> with:
> 
>   http://redhat.com/~mingo/misc/config-Mon_Jun_30_08_17_42_CEST_2008.bad
> 
> and comparing the 32-bit and unified version is not simple and the 
> commit is rather large.
> 
> I'm sure the fix is simple, but this bug shows a structural problem with 
> this unification patch. The proper way to unify files is to first bring 
> both the 32-bit and the 64-bit version up to a unified form via 
> finegrained changes, so that uaccess_32.h and uaccess_64.h becomes 
> exactly the same file.
> 
> ... _then_ only, in a final 'mechanic unification' step the two files 
> are merged into uaccess.h. (but no change is done to the content)
> 
> If anything breaks during such a series it's bisectable to a finegrained 
> patch on either the 32-bit or the 64-bit side. If this commit was shaped 
> that way i could now report to you the exact bisection result - instead 
> of this too-broad bisection result.
> 
> So please rework this commit in that fashion (not just to fix this 
> breakage but in anticipation of future commits) - uaccess.h is central 
> enough for us to be super careful about it.
> 
> 	Ingo
Fair.

However, as I wrote in the first patch of the series, I'm not doing a 
complete unification of uaccess.h. Part of it is left for future work, 
since it's a little bit trickier.

So I didn't have the option of a mechanical move. I did tried, however, 
to make sure this patch was only a code move, with everything that is 
going to the common file being equal in both files.

Needless to say, I failed. ;-) This was for a very tiny piece, but still...

The options I see are:

* to redo the uaccess.h unification this way, making sure a diff between 
the diffs of the arch-files report nothing different, or:
* to remove the topmost patches that touches uaccess*.h, and leave only 
the ones that integrate the .c and .S files, until I can really 
integrate the whole of it.

For the second, however, although I was careful to make incremental 
changes, some small differences may exist. Examples of these differences 
are places in which I introduce a few ifdefs. It's close to nothing, but 
still not mechanical. Because of that, you might want me to redo the 
whole series.

Your call.

