Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbZLQXZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbZLQXZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760576AbZLQXZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:25:15 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:43694 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759197AbZLQXZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:25:14 -0500
Message-ID: <4B2ABDC8.6090104@knaff.lu>
Date: Fri, 18 Dec 2009 00:24:56 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>, markh@compro.net
CC: fdutils@fdutils.linux.lu, linux-kernel@vger.kernel.org
Subject: Re: DMA cache consistency bug introduced in 2.6.28 (Was: Re: [Fdutils]
 Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com> <4B275D37.4090807@cfl.rr.com> <4B2761E9.2030301@knaff.lu> <4B276513.6030509@cfl.rr.com> <4B276753.80807@knaff.lu> <4B27983F.5090600@compro.net> <4B27EF18.7050101@knaff.lu> <4B28FDEB.3030800@compro.net> <4B290029.90602@knaff.lu> <4B2901DB.8040403@compro.net> <4B29052B.9070406@knaff.lu> <4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu> <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain> <4B2A98BB.5080406@knaff.lu> <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain> <4B2AAC87.5000703@knaff.lu> <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 17 Dec 2009, Alain Knaff wrote:
>> [...]
>>> You'd need a git tree that contains both the working and non-working 
>>> versions, and then literally just do
>>>
>>> 	git bisect start
>>> 	git bisect good <known good version number here>
>>> 	git bisect bad <known bad version here>
>>>
>>> and it will give you a commit to try. Compile, test, see if it's good or 
>>> bad, and do
>>>
>>> 	git bisect [good|bad]
>>>
>>> depending on the result. Rinse and repeat (depending on how tight the 
>>> initial good/bad commits were, it will need 10-15 kernel tests).
>> ... and how do I check out the most recent good / oldest bad kernel for
>> compilation?
> 
> 'git bisect' does all that for you. You don't need to check out the 
> kernels you mark good or bad - git will just calculate the commit graphs, 
> and pick a commit that is in the "middle" between them, and check out that 
> commit.
> 
>>> So after a successful bisect, it is usually a good idea to try to go back 
>>> to the original known-bad kernel, and then revert the commit that was 
>>> indicated as the bad one (assuming the revert works - it could be that the 
>>> bad one ends up being fundamental to other commits after it), and test 
>>> that yes, that really fixes the bug.
>> What command lines would I use for that revert?
> 
> 	git revert <sha1-that-git-bisect-reported>
> 
> but even if that revert isn't successful, just the bisection result will 
> be very interesting (assuming it all looks sane, of course - as mentioned, 
> sometimes bisect results get screwed up because the bug isn't entirely 
> reproducible due to timing etc).
> 
> 			Linus

thanks for these explanations, that makes it clearer indeed.

Now, I only need to find a machine locally to test this on. Or Mark: are
you confident in doing this yourself?

Thanks,

Alain

