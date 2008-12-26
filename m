Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYLZHIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYLZHIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYLZHIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:08:15 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:64805 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYLZHIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:08:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=xNjjdpKxADuvs+PqYY4WzIJBCrmpxJCvq3QoH2Ly02kjaHfeqGqZOvJVl+SvioUKB3
         Ptws/fecVzcp/9sot05NxJOgKy8N1LVZ2o62iEOzaFb3BpeyadbfTew+7LOY+50FMWL7
         ri8kvZV6BOledZ5PgBIwdtFQj+HNENGIclFlo=
Date: Fri, 26 Dec 2008 15:06:53 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: xiyou.wangcong@gmail.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Check return from argv_split() in do_coredump().
Message-ID: <20081226150653.GD3156@hack.private>
References: <200812240616.mBO6GGEe078727@www262.sakura.ne.jp> <20081226144548.GB3156@hack.private> <200812260700.mBQ70uH3009595@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200812260700.mBQ70uH3009595@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 04:00:56PM +0900, Tetsuo Handa wrote:
>Hello.
>
>Am$(D+1rico Wang wrote:
>> How about going to the line:
>> 
>>         current->fsuid = fsuid;
>> 
>> ? Because when argv_split() fails, helper_argv is NULL and doesn't need
>> to be checked again.
>
>I didn't understand what you say. I'm saying that
>"do_coredump() may accesss helper_argv[0] when helper_argv == NULL",
>which will result in "NULL pointer dereference" problem.
>Yes, this problem unlikely happens. Thus,
>
>if (!helper_argv)
>	goto fail_unlock;
>
>may be enough.
>

Yes, goto fail_unlock will go to this line:

        if (helper_argv)
	                argv_free(helper_argv);

but in this situation, helper_argv is known as NULL, thus another
check doesn't need. So we can go to the line below, i.e.

fail_unlock:
        if (helper_argv)
	                argv_free(helper_argv);

        current->fsuid = fsuid; //<=== goto this line
        coredump_finish(mm);

You need to add a new label, of course. :)

-- 
"Against stupidity, the gods themselves, contend in vain."

