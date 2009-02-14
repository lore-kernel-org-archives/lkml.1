Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbZBNHJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbZBNHJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 02:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZBNHJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 02:09:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54092 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZBNHJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 02:09:04 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <m1vdrdveis.fsf@fess.ebiederm.org> <499661E9.3070809@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 13 Feb 2009 23:09:09 -0800
In-Reply-To: <499661E9.3070809@zytor.com> (H. Peter Anvin's message of "Fri\, 13 Feb 2009 22\:17\:13 -0800")
Message-ID: <m1hc2xa416.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] i386 pci: Handle mmaping 64bit bars.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> While reading through pci_mmap_page_range I realized that if don't
>> properly handle 64bit bars in the 32bit kernel.
>> 
>> Without the added cast the shift will be done in 32bit despite being
>> assigned to a 64bit variable and if we are mmaping an address above
>> 4G things will do the wrong thing.
>
> Hm... this really should be resource_size_t, no?
>
>> -	u64 addr = vma->vm_pgoff << PAGE_SHIFT;
>> +	u64 addr = ((u64)vma->vm_pgoff) << PAGE_SHIFT;

It is a parameter to the reserve_memtype and free_memtype functions,
which take a u64 so the type looks ok.

If I was going to quibble I would argue that those functions should
take a pfn instead of a u64...

Eric
