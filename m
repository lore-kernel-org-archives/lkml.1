Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbXEPPlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbXEPPlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbXEPPlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:41:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:43530 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbXEPPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gBvaYKn+m6Kl7HXDsRKwjQuPbzKmG9IYCxGDpjGEXEu/yEHjtCQedIgcLwIN19pegA70EhOmEr07XHw0bb3szVHSvxyhOnS+0mKrCCWrouTuzrfU+QIj+1673slPS255a9afM9X6sqJwOKlKpff7D1tyExlddgzNRCqoVoI1wbM=
Message-ID: <464B2605.9040200@gmail.com>
Date: Wed, 16 May 2007 17:40:53 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Greg KH <greg@kroah.com>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
References: <464A4F56.6080108@tequila.co.jp>	<20070515185350.2e77bf21.akpm@linux-foundation.org>	<464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org>
In-Reply-To: <20070516082935.fe112ab5.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>> a number of people have hit that, on and off.
>> Yeah, I've been seeing that one.  It should have been fixed with the big
>> fat patchset.
> 
> Great - fingers crossed.
> 
>>> We were close to having a fix, I think, but then we decided that great
>>> chunks of sysfs needed rewriting and I believe that we believe that this
>>> great rewrite will fix this bug.
>> How were we gonna fix it?  If it isn't too complex, I can cook up a
>> patch for -stable series.
> 
> Do we actually understand the causes?

Yeah, I think I do.  Basically, the problem is that on-demand attach and
reclamation update sd->s_dentry but accesses to it aren't synchronized
properly.  In the big fat patchset, first I tried to fix it by removing
sd->s_dentry completely which didn't work because of shadow nodes, so
the second try was to fix the synchronization which is in -mm now.

>>  The safest approach I can think of is making
>> dentries for attributes unreclaimable but those are made reclaimable for
>> good reasons.  :-(
> 
> Yeah, that was the google workaround.  It's OK unless you happen to have
> thousands of disks on an ia32 box.

I see.  I thought there was different approach on fixing the problem.
I'll try to backport the synchronization fix but am afraid it can be too
risky for -stable.  If it seems too risky, I'll send a patch to disable
reclamation.

-- 
tejun
