Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYKUQS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYKUQS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYKUQSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:18:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbYKUQSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:18:47 -0500
Date: Fri, 21 Nov 2008 17:18:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] x86: disable virt on kdump and emergency_restart
	(v4)
Message-ID: <20081121161807.GB24839@elte.hu>
References: <1226955804-16802-1-git-send-email-ehabkost@redhat.com> <20081118081501.GF17838@elte.hu> <4926DCC8.1040500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4926DCC8.1040500@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Ingo Molnar wrote:
>> * Eduardo Habkost <ehabkost@redhat.com> wrote:
>>
>>   
>>> Hi, Ingo,
>>>
>>> This is yet another spin of the series to disable vmx on kdump and  
>>> on emergency_restart, after some feedback from Avi.
>>>     
>>
>> this is going to interact with the KVM tree, wont it?
>>
>> i think the best way forward would be to keep your changes in the KVM  
>> tree.
>>
>> Lets try a Git trick for that. Avi could do that by pulling your other  
>> x86 changes from the x86 topic tree into the kvm tree. They are  
>> reviewed, acked and well-tested now, and kept in a separate tree so no  
>> other x86 change will be pulled in via them.
>>
>> We can do this if Avi can guarantee that these commits wont ever be  
>> rebased within KVM - then the two trees will merge up just fine in  
>> linux-next (and later in v2.6.29 as well), without any awkward merge  
>> dependencies or merge conflicts.
>>   
>
> I never rebase kvm.git master, so I pulled the x86 changes and 
> applied all.  Ingo, this will mean you have to push x86 before 
> kvm.git, but as you're generally faster than me there shouldn't be a 
> problem.

Great!

Note that the dependencies are even more relaxed that that: you can 
push it too via the KVM tree, independently of the x86 push. Obviously 
you got those x86 changes from us x86 maintainers and they all work 
standalone too.

Pulling from each other means both sides agree on that sub-set of 
changes and trust each other - so there's no forced merge ordering or 
maintenance boundaries - any side can merge it upstream. (If you feel 
uneasy about it on any level, and were you to send a pull request 
first, then you can point it out to Linus in the pull request that you 
got those changes from us.)

	Ingo
