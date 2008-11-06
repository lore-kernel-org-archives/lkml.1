Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYKFKc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYKFKc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYKFKcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:32:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33016 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYKFKcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:32:13 -0500
Message-ID: <4912C75B.8050508@redhat.com>
Date: Thu, 06 Nov 2008 12:30:51 +0200
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
Subject: Re: [PATCH 08/16] x86: Emergency virtualization disable function
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>	<1225810364-8990-9-git-send-email-ehabkost@redhat.com>	<m1bpwu3wod.fsf@frodo.ebiederm.org> <20081105175235.GJ5247@blackpad>	<4912BD67.8000704@redhat.com> <m1mygd2lxs.fsf@frodo.ebiederm.org>
In-Reply-To: <m1mygd2lxs.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>
>> If you want to be extra simple and safe, remove kvm from the equation.  Make the
>> disabling code part of kdump/emergency_restart and only rely on the convention
>> that cr3.vmxe == vmxon.
>>     
> Convention?
>   

There is a de-facto convention supported by at least vmware and kvm.  If 
cr4.vmxe is 1, then we are in vmx operation.  If cr4.vmxe is 0, then we 
are not in vmx operation.  This allows us to determine whether we need 
to execute vmxoff without any APIs.


-- 
error compiling committee.c: too many arguments to function

