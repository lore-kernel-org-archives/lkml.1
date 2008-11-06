Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYKFJpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYKFJpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYKFJpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:45:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53967 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYKFJpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:45:22 -0500
Message-ID: <4912BC86.8050607@redhat.com>
Date: Thu, 06 Nov 2008 11:44:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] kvm: x86: set kdump virt_disable function on initialization
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>	<1225810364-8990-16-git-send-email-ehabkost@redhat.com> <m1od0u3wyq.fsf@frodo.ebiederm.org>
In-Reply-To: <m1od0u3wyq.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>  
>> +	r = set_virt_disable_func(crash_hardware_disable);
>>     
>
> Can we make this say:
> set_virt_disable_func(kvm_x86_ops->crash_hardware_disable);
>
> So we can avoid going through 2 levels of function pointers?
> I find that a little scary in code that might be running
> at the edge of stack overflow.
>   

Actually, with scheduling disabled we can overflow the stack as much as 
we like.  It will reduce the quality of the dump, but everything ought 
to work.

-- 
error compiling committee.c: too many arguments to function

