Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZGTTXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZGTTXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGTTXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:23:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53010 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZGTTXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:23:04 -0400
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Brayan Arraes <brayan@yack.com.br>, LKML <linux-kernel@vger.kernel.org>
References: <4A64672E.8020005@cn.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 20 Jul 2009 12:22:57 -0700
In-Reply-To: <4A64672E.8020005@cn.fujitsu.com> (Lai Jiangshan's message of "Mon\, 20 Jul 2009 20\:46\:38 +0800")
Message-ID: <m1d47vnoq6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, brayan@yack.com.br, vgoyal@redhat.com, nhorman@tuxdriver.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lai Jiangshan <laijs@cn.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c handler"
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan <laijs@cn.fujitsu.com> writes:

> 1) This fix breaks our tools.
>       This fix changes the ABI. panic_on_oops is default 0,
>    and a lots system do not specify the boot option "panic",
>    thus, Sysrq-c will not cause CrashDump(Kdump) as expected.

How does it break your tools?

> 2) When CONFIG_KEXEC=n, Sysrq-c should become an invalid
>    command like Sysrq-D(CONFIG_LOCKDEP, show-all-locks).
>    But this fix makes it a valid command and let it do a
>    hazard thing: cause a page fault(NULL dereference) in kernel.
>
> So, we revert this fix.

The idea was to extend sysrq-d to also be a way of testing NULL
pointer dereferences.  How is that a bad idea?

Eric
