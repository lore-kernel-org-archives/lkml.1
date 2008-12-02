Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYLBNgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYLBNgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYLBNgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:36:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:27203 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYLBNgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YMzaNu/TThitgWU0FBbsnApItrS7Ax7/Y6MVP/3jOag8FWa+SV5cDgVeZtECpca1Nb
         g18WhFX4vIxj7VBKeFDEjQkKKw/DlVBcVD8XeN0LlagoqlcZMSf4oi0JaGZX0BRg8rH6
         aIrsO/Qw/f2H6BIsi4MvaMul/JjNiWkyDmR1k=
Message-ID: <3da2c0120812020536h31136aeemf56c2e71c0920c38@mail.gmail.com>
Date: Tue, 2 Dec 2008 19:06:21 +0530
From: "sudhir kumar" <imsudhirkumar@gmail.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: BUG: CGROUPS [2.6.28-rc6] Task migration does not clean reference to group
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, skumar@linux.vnet.ibm.com,
       Peter <a.p.zijlstra@chello.nl>, "Paul Menage" <menage@google.com>,
       mingo@elte.hu
In-Reply-To: <49353322.6090802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3da2c0120812020100u66a94f9bk3c0e8a705bb6347e@mail.gmail.com>
	 <49353322.6090802@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 6:37 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> sudhir kumar wrote:
>> Hi,
>> I see an interesting bug in the cgroups. I found that cat /proc/cgroups
>> does not decrease the num_cgroups field when a group is deleted. It looks
>> to me that somewhere we miss to delete the reference, which leads to a failure
>> to unmount the cgroups filesystem.
>
> Ah, it's not a bug. :)
Oh Sorry!
>
>> The steps to produce the bug are:
>>
>> mkdir /cpu
>> mount -t cgroup -ocpu cgroup /cpu
>> cd cpu
>> mkdir group1;
>> cd group1;
>> /./while &              # an infinite loop
>
> Seems whenever we create a background job, we'll have a pin to the directory where
> the job is created. So though rmdir() removed the directory, the dentry's refcnt
Thanks for that.
Should not rmdir fail in such a case ? Otherwise there is no other way
for the user than to kill his task and unmount the cgroup fs, in case
he needs to do so. Or shall we change the pin to point to the target
directory? No idea if I am demanding too much ;(


Thanks
Sudhir
