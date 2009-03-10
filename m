Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZCJBhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZCJBhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZCJBhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:37:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34030 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbZCJBhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:37:07 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49B5AD6A.2020101@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 09 Mar 2009 18:36:57 -0700
In-Reply-To: <49B5AD6A.2020101@goop.org> (Jeremy Fitzhardinge's message of "Mon\, 09 Mar 2009 16\:59\:38 -0700")
Message-ID: <m1mybu40qu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jeremy@goop.org, linux-kernel@vger.kernel.org, x86@kernel.org, mingo@elte.hu, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Absolute symbols in vmlinux_64.lds.S
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Why does vmlinux_64.lds.S use absolute symbols for things like __bss_start/stop:
>
>  __bss_start = .;		/* BSS */
>  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
> 	*(.bss.page_aligned)
> 	*(.bss)
> 	}
>  __bss_stop = .;
>
>
> vmlinux_32.lds.S puts __bss_start/stop into the .bss section itself.  Is there
> some particular reason they need to be absolute symbols (relocation?).

It is more that in vmlinux_32.lds.S they needed to be section relative, to
deal with relocation.

For the 64bit kernel the relocation happens at the level under the page table
so does not show up in vmlinux_64.lds.S.  Which means it was probably
laziness that didn't get it changed simply because it hasn't matter.

Eric
