Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYKFKZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYKFKZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYKFKZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:25:25 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56447 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbYKFKZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:25:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Avi Kivity <avi@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
	<1225810364-8990-9-git-send-email-ehabkost@redhat.com>
	<m1bpwu3wod.fsf@frodo.ebiederm.org> <20081105175235.GJ5247@blackpad>
	<4912BD67.8000704@redhat.com>
Date: Thu, 06 Nov 2008 02:22:39 -0800
In-Reply-To: <4912BD67.8000704@redhat.com> (Avi Kivity's message of "Thu, 06
	Nov 2008 11:48:23 +0200")
Message-ID: <m1mygd2lxs.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Avi Kivity <avi@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4853]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 08/16] x86: Emergency virtualization disable function
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> Eduardo Habkost wrote:
>> We could move the set_virt_disable_func() calls to vmx.c and svm.c (on
>> hardware_setup/hardware_unsetup). One could argue that it is sort of a
>> coincidence that we need the code for both vmx and svm.
>>
>
> I don't share this fear of function calls, but perhaps that's due to lack of
> experience with kdump.

Mostly I'm just afraid of extra complexity.

> If you want to be extra simple and safe, remove kvm from the equation.  Make the
> disabling code part of kdump/emergency_restart and only rely on the convention
> that cr3.vmxe == vmxon.
Convention?

> That has the advantage of working with other virtualization systems as well.

Sounds good.

Eric

