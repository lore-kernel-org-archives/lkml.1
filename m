Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYKUQIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYKUQIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYKUQIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:08:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47840 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbYKUQIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:08:14 -0500
Message-ID: <4926DCC8.1040500@redhat.com>
Date: Fri, 21 Nov 2008 18:07:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eduardo Habkost <ehabkost@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] x86: disable virt on kdump and emergency_restart
 (v4)
References: <1226955804-16802-1-git-send-email-ehabkost@redhat.com> <20081118081501.GF17838@elte.hu>
In-Reply-To: <20081118081501.GF17838@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Eduardo Habkost <ehabkost@redhat.com> wrote:
>
>   
>> Hi, Ingo,
>>
>> This is yet another spin of the series to disable vmx on kdump and 
>> on emergency_restart, after some feedback from Avi.
>>     
>
> this is going to interact with the KVM tree, wont it?
>
> i think the best way forward would be to keep your changes in the KVM 
> tree.
>
> Lets try a Git trick for that. Avi could do that by pulling your other 
> x86 changes from the x86 topic tree into the kvm tree. They are 
> reviewed, acked and well-tested now, and kept in a separate tree so no 
> other x86 change will be pulled in via them.
>
> We can do this if Avi can guarantee that these commits wont ever be 
> rebased within KVM - then the two trees will merge up just fine in 
> linux-next (and later in v2.6.29 as well), without any awkward merge 
> dependencies or merge conflicts.
>   

I never rebase kvm.git master, so I pulled the x86 changes and applied 
all.  Ingo, this will mean you have to push x86 before kvm.git, but as 
you're generally faster than me there shouldn't be a problem.

Eduardo, please check the merge (there was a small conflict in reboot.c 
which I fixed) once I push it.  Also, when generating patches that move 
files, use the -M switch: this makes it easier to review, and also 
handles files that change better.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

