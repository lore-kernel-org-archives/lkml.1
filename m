Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYLJIqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYLJIqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 03:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbYLJIqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 03:46:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50248 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbYLJIqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 03:46:38 -0500
Message-ID: <493F81E9.90306@redhat.com>
Date: Wed, 10 Dec 2008 10:46:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/45] KVM: x86: Support for user space injected NMIs
References: <1228736216-15787-1-git-send-email-avi@redhat.com> <1228736216-15787-13-git-send-email-avi@redhat.com> <493D0E0A.2000400@siemens.com>
In-Reply-To: <493D0E0A.2000400@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Avi Kivity wrote:
>   
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> Introduces the KVM_NMI IOCTL to the generic x86 part of KVM for
>> injecting NMIs from user space and also extends the statistic report
>> accordingly.
>>     
> Avi, please consider [1] again. You've already merged the related user
> space cleanup, and I was just waiting for your comment on how to deal
> with the kernel part, ideally _before_ merging the superfluous
> ready_for/request NMI interface into mainline.
>
> Thanks,
> Jan
>
> [1] http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/25016
>
>   

Do you mean, drop these nmi window bits completely from 2.6.29, keeping 
just injection?  We can do that without breaking released userspace by 
dropping KVM_CAP_NMI and adding KVM_CAP_NMI2 (better name?) that doesn't 
have interrupt window support.

This means that userspace versions that supported KVM_CAP_NMI will not 
work with 2.6.29, but I think we can live with that.

If this is acceptable, please send a patch that converts KVM_CAP_NMI to 
KVM_CAP_NMI2, and a corresponding patch for userspace.  I will fold the 
kernel patch into the 2.6.29 submission, and apply both patches to the 
master branch.

-- 
error compiling committee.c: too many arguments to function

