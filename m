Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbZBDPh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbZBDPh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZBDPhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:37:08 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56179 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZBDPhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:37:05 -0500
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Horman <horms@verge.net.au>, hbabu@us.ibm.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
References: <20090119212127.GA13157@hmsreliant.think-freely.org>
	<20090120141551.GA5125@redhat.com>
	<20090120150958.GB18207@hmsreliant.think-freely.org>
	<20090120152255.GB5125@redhat.com>
	<20090127001211.f847ea5a.akpm@linux-foundation.org>
	<20090128041109.GA4943@verge.net.au>
	<m1ljsnz1up.fsf@fess.ebiederm.org>
	<20090204120549.GA2182@hmsreliant.think-freely.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Feb 2009 07:37:16 -0800
In-Reply-To: <20090204120549.GA2182@hmsreliant.think-freely.org> (Neil Horman's message of "Wed\, 4 Feb 2009 07\:05\:49 -0500")
Message-ID: <m1y6wmxlg3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: nhorman@tuxdriver.com, vgoyal@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hbabu@us.ibm.com, horms@verge.net.au
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Neil Horman <nhorman@tuxdriver.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.0 XM_Sft_Brands_C00 XM_Sft_Brands_C00
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH]: add dmesg log symbols to /proc/vmcoreinfo lists
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

>> 
>> That aside we aren't currently exporting log_buf_len, so I don't
>> think this code works actually works.
>> 
>> Neil can you add a comment in kernel/printk.c of the algorithm
>> necessary for external tools to decode the ring buffer?
>> 
>> We need the comment because people working on kernel/printk.c
>> need to know what is happening and without having to review lots
>> of user space code, and we need the comment to verify that we
>> are exporting the right things.
>> 
>
> Ok, as per Erics comment, I've written this.  It applies on top of whats already
> in your tree Andrew.  It adds some comments on the function in question so that
> anyone working on printk.c will know why we're exporting their symbols.  It also
> modifies slightly the symbols we are exporting so that we can handle dmesg
> buffers that are longer than the standard PAGE_SIZE configuration, and lets us
> detect and handle buffer wraps.

Looks like a good start but what is the algorithm for using the variables?
Given a kernel core file how do you extract the dmesg ring buffer?

It still does not appear obvious to me that you are extracting the
dmesg ring buffer correctly or easily.

Eric
