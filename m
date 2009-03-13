Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbZCMW37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbZCMW37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbZCMW3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:29:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41418 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZCMW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:29:49 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <49B80F7B.2020007@kernel.org> <49B88F80.3080203@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 13 Mar 2009 15:29:39 -0700
In-Reply-To: <49B88F80.3080203@zytor.com> (H. Peter Anvin's message of "Wed\, 11 Mar 2009 21\:28\:48 -0700")
Message-ID: <m1mybpt5t8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: relocs is only used with 32bit
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Hi Yinghai,
>
> In general I prefer minimizing the conditional sections rather than
> maximizing them.  If nothing else, it catches errors earlier that way,
> and makes it easier to eventually eliminate them entirely.

Makes sense.  Although in this case that rule appears like it
can't even execute on x86_64.

The architectural differences result in different tradeoffs so the
relocation design is completely different on x86_64 and x86_32.

On x86_64 we just change the underlying page tables to point
at different physical addresses and have a fixed virtual address.
Since x86_64 is best with short (< 2GB) offsets that is a fairly
optimal.

On x86_32 where address space is precious and it doesn't really
matter where the kernel lives we take a 5% or so size penalty
to hold relocations in the binary and update the kernel at boot
time so everything assumes we run at the loaded address.

With the result that we need a link time helper on x86_32 and
not on x86_64.

Eric

