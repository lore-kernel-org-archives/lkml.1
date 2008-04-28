Return-Path: <linux-kernel-owner+w=401wt.eu-S965460AbYD1Rbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965460AbYD1Rbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934307AbYD1Rbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:31:35 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:14632 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbYD1Rbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sP9nvzC/8cPWlgrWdkWxM1Ja+sS1pZzUz7ocoz8ddiASUPSg1J8QsIowOJ2KrwsUf2nqHZFK2UHTtwEYFXnuZ5tMIjabHLZKbqZcE2a9xWOurYsWtcnAgEmje/knYo40BkEWIg3jdzF7Az/NbfFWM/ie1evFABzgRUTq62At6Gk=
Message-ID: <36ca99e90804281031v5b211833sfb7cda05fedcea6@mail.gmail.com>
Date: Mon, 28 Apr 2008 19:31:31 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH] Fix calculus of bitmap_scnprintf_len()
Cc: "Paul Jackson" <pj@sgi.com>, "WANG Cong" <xiyou.wangcong@gmail.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
In-Reply-To: <481604BD.7000009@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209329003-22036-1-git-send-email-bert.wesarg@googlemail.com>
	 <20080427160118.ad4cadf0.pj@sgi.com>
	 <alpine.LFD.1.00.0804281414020.2870@localhost.localdomain>
	 <20080428081326.fc62f1ce.pj@sgi.com> <481604BD.7000009@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 7:09 PM, Mike Travis <travis@sgi.com> wrote:
> Paul Jackson wrote:
>  > Bert wrote:
>  >> The function bitmap_scnprintf_len() is currently not used
>  >
>  > Paul Jackson wrote:
>  >> How about we just remove that function?
>  >
>  > WANG Cong wrote:
>  >> I am afraid no. See:
>  >>
>  >> include/linux/cpumask.h:292:    return bitmap_scnprintf_len(len);
>  >
>  > Good point.
>  >
>  >
>  > Then how about we also remove from cpumask.h:
>  >
>  > #define cpumask_scnprintf_len(len) \
>  >                         __cpumask_scnprintf_len((len))
>  > static inline int __cpumask_scnprintf_len(int len)
>  > {
>  >         return bitmap_scnprintf_len(len);
>  > }
>  >
>
>  That's fine with me.  A later version of the patch did have
>  the function removed but it didn't get picked up.  The other
>  changes there were to use function pointers instead of the
>  flag variable to select list or mask output format, and the
>  addition of mask variants for the cpu/{present,possible,
>  online,system} map outputs.
I'm fine with this too. I did a hasty audit of cpumask_scnprintf()
users, and no one can use these functions.

But one last note to the cpumask_scnprintf_len() macro: this macro
should really not have an argument, it should be forced to NR_CPUS.
Else a user could have a too small buffer for the call to
cpumask_scnprintf(), which always calls bitmap_scnprintf() with
NR_CPUS nbits.

>
>  I'll dig that one back up and resubmit it.
Fine.

Regards.
Bert
>
>  Thanks,
>  Mike
>
