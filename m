Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZBCUp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZBCUp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZBCUpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:45:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50165 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZBCUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:45:10 -0500
To: Simon Horman <horms@verge.net.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Biederman <ebiederm@xmision.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Vivek Goyal <vgoyal@redhat.com>
References: <20090119212127.GA13157@hmsreliant.think-freely.org>
	<20090120141551.GA5125@redhat.com>
	<20090120150958.GB18207@hmsreliant.think-freely.org>
	<20090120152255.GB5125@redhat.com>
	<20090127001211.f847ea5a.akpm@linux-foundation.org>
	<20090128041109.GA4943@verge.net.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Feb 2009 12:45:18 -0800
In-Reply-To: <20090128041109.GA4943@verge.net.au> (Simon Horman's message of "Wed\, 28 Jan 2009 15\:11\:34 +1100")
Message-ID: <m1ljsnz1up.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: horms@verge.net.au, vgoyal@redhat.com, hbabu@us.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, ebiederm@xmision.com, nhorman@tuxdriver.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Simon Horman <horms@verge.net.au>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.0 XM_Sft_Brands_C00 XM_Sft_Brands_C00
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH]: add dmesg log symbols to /proc/vmcoreinfo lists
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman <horms@verge.net.au> writes:

>> I also did all the below.  Please check it.  (Is anyone else reading all
>> this stuff??)
>
> These look fine to me. Unfortunately they don't apply to the version
> of Linus' tree that I have checked out and I'm away from net access
> at this moment (though obviously not by the time this message reaches you).
> I'll update my tree and check once I'm back online.
>
> Eric Biederman usually watches kexec stuff. I'm pretty sure he
> is on the kexec mailing list, but I've CCed him anyway.

Thanks.

The question at head seems to be does it make sense to always
export log_buf and log_end in the VMCOREINFO section of the
core file we generate.

The premise of VMCOREINFO is that it gives crash or other
analysis tools enough information to pair a core dump with
a vmlinux and decipher the page table layout.  In general
things that are tricky to infer from just the core dump,
and the vmlinux.

Do log_buf and log_end fall in that category?

They are certainly important enough and they are symbols that
are tricky to find. That said I think we should also have 
this information exported so that we can get at
it with kgdb, jtag debuggers, and other weird debugging tools.
Do we have that already?  It doesn't look like it.  That
may be an argument for a different interface.

That aside we aren't currently exporting log_buf_len, so I don't
think this code works actually works.

Neil can you add a comment in kernel/printk.c of the algorithm
necessary for external tools to decode the ring buffer?

We need the comment because people working on kernel/printk.c
need to know what is happening and without having to review lots
of user space code, and we need the comment to verify that we
are exporting the right things.

Eric
