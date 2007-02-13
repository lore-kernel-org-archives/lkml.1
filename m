Return-Path: <linux-kernel-owner+w=401wt.eu-S1751210AbXBMJDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbXBMJDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXBMJDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:03:22 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56074 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbXBMJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:03:20 -0500
Message-ID: <45D17F8D.3020207@bull.net>
Date: Tue, 13 Feb 2007 10:06:21 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components
References: <20070116061516.899460000@bull.net>	<20070116063030.761795000@bull.net>	<20070122115638.835b26a1.akpm@osdl.org> <45B61E50.6020607@bull.net>	<m1mz3poeda.fsf@ebiederm.dsl.xmission.com> <45CC68BA.4010403@bull.net> <m11wkz5gd2.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m11wkz5gd2.fsf@ebiederm.dsl.xmission.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/02/2007 10:04:30,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/02/2007 10:04:31,
	Serialize complete at 13/02/2007 10:04:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nadia Derbey <Nadia.Derbey@bull.net> writes:
> 
> 
>>I do not fully agree with you:
>>It is true that some ipc tunables play the role of DoS limits.
>>But IMHO the *mni ones (semmni, msgmni, shmmni) are used by the ipc subsystem to
>>adapt its data structures sizes to what is being asked for through the tunable
>>value. I think this is how they manage to take into account a new tunable value
>>without a need for rebooting the system: reallocate some more memory on demand.
> 
> 
> Yes, they do.  However if you are constantly having to play with shmmni or
> the others that is the problem and the array should be replaced with
> a hash table or some form of radix tree, so it changes it's size to fit
> the need.  Once that is done, shmmni does become a simple DOS limit.
> 
> So what I'm asking is please fix the problem at the source don't plaster over
> it.
> 
> 
>>Now, what the akt framework does, is that it takes advantage of this concept of
>>"on demand memory allocation" to replace a user (or a daemon) that would
>>periodically check its ipcs consumptions and manually adjust the ipcs tunables:
>>Doing this from the user space would imply a latency that makes it difficult to
>>react fast enough to resources running out.
> 
> 
> There may be some sense in this but you haven't found something that inherently
> needs tuning.  You have found something that has a poor data structure,
> and can more easily be fixed by simply fixing the data structure.

So, should I understand from this that automatic tuning and the AKT 
framework itself would make sense, given that I find the rigth tunables 
it should be applied to?
Actually, dont' know if you had the opportunity to read all the patches, 
but there are 2 other tunables AKT is proposed to be applied to:
. max_threads, the tunable limit on nr_threads
. max_files, the tunable limit on nr_files

Regards,
Nadia

