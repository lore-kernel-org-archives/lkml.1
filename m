Return-Path: <linux-kernel-owner+w=401wt.eu-S1751247AbXBMKPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbXBMKPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXBMKPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:15:53 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48713 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbXBMKPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:15:52 -0500
Message-ID: <45D1908F.8080804@bull.net>
Date: Tue, 13 Feb 2007 11:18:55 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
Cc: akpm@osdl.org, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] AKT - Tunable structure and registration routines
References: <20070130101143.296619000@bull.net>	<20070130102908.781457000@bull.net> <p73y7n3fm7t.fsf@bingen.suse.de>
In-Reply-To: <p73y7n3fm7t.fsf@bingen.suse.de>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/02/2007 11:17:04,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/02/2007 11:17:05,
	Serialize complete at 13/02/2007 11:17:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Nadia.Derbey@bull.net writes:
> 
>>+
>>+This feature aims at making the kernel automatically change the tunables
>>+values as it sees resources running out.
> 
> 
> The only reason we have resource limit is to avoid DOS when one
> resource consumes too much memory.  When there is no such danger then
> there isn't any reason to have a limit at all and it could be just
> eliminated (or set to unlimited by default)

Automatic tuning is a way to set the limit to unlimited, in a sense, 
doesn't it? With this feature, we can leave the default limits as they 
are for an "every-day" usage, and when a particular application runs on 
the machine, authorize the limit to grow up as needed.

> 
> Your feature doesn't address the DOS and without that there isn't
> any reason to have limits at all. So what's the point? 

As I told Eric Biederman in another mail, DoS in ensured in AKT by 
exporting the min and max values for each tunable to sysfs (actually 
Eric complained about these min and max :-( ). These are RW atrributes 
that make it possible for a sysadmin to set the max value a tunable can 
ever reach, instead of letting it grow up to huge values.

> 
> I agree that some of the default limits we have are not very useful
> on modern machines. I guess you're trying to address that.

Yep

> 
> I would suggest the following strategy:
> 
> - Review any limits we have and make sure they make sense.
> 
> - Figure out if they actually serve a useful purpose 
> e.g. what happens when they are exceeded, is there a DOS?. 
> If yes can  the DOS be addressed in a better way (e.g. by allowing to shrink
> the resource by a shrinker callback).
>  
> Some of the existing limits are clearly bogus, e.g. the limit
> on shared memory.
> 
> For others i don't see a good alternative. e.g. if you don't limit
> the number of files allocated the only alternative would be to kill
> processes when they allocate too many files. Is that really preferable
> to a errno? 

Agree with you, BUT between the default max_files and the "too many 
files" situation, there is a gap that can be crossed by automatically 
tuning max_files, isn't there? e.g. max_file default value is NR_FILE 
(0x2000), while Oracle expects to have it set to 0x10000.

> 
> - If they serve a useful purpose then check if the default is useful
> on a modern machine. Or make them scale with the amount of memory
> like many limits already do.
> 
> -Andi
> 

Regards,
Nadia

