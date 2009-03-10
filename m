Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZCJFtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZCJFtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZCJFtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:49:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52355 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZCJFta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:49:30 -0400
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49B5AD6A.2020101@goop.org> <49B5C12B.1020108@kernel.org>
	<20090310053721.GA25977@uranus.ravnborg.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 09 Mar 2009 22:49:21 -0700
In-Reply-To: <20090310053721.GA25977@uranus.ravnborg.org> (Sam Ravnborg's message of "Tue\, 10 Mar 2009 06\:37\:21 +0100")
Message-ID: <m1bpsa6i72.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: sam@ravnborg.org, linux-kernel@vger.kernel.org, x86@kernel.org, mingo@elte.hu, jeremy@goop.org, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sam Ravnborg <sam@ravnborg.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Absolute symbols in vmlinux_64.lds.S
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:

> On Mon, Mar 09, 2009 at 06:23:55PM -0700, Yinghai Lu wrote:
>> Jeremy Fitzhardinge wrote:
>> > Why does vmlinux_64.lds.S use absolute symbols for things like
>> > __bss_start/stop:
>> > 
>> >  __bss_start = .;        /* BSS */
>> >  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
>> >     *(.bss.page_aligned)
>> >     *(.bss)
>> >     }
>> >  __bss_stop = .;
>> > 
>> > 
>> > vmlinux_32.lds.S puts __bss_start/stop into the .bss section itself.  Is
>> > there some particular reason they need to be absolute symbols
>> > (relocation?).
>> > 
>> 
>> they are the same.
>
> Thats depends on the value of '.' where you assign __bss_start.
> We have had several bugs where the symbol assinged outside the
> section was less than expected because the linker aling the
> start of the section equal to the lrgest alignment requirement
> of a member in the section.
>
> So in this case if '.' equals to 0xabcd and the lagest
> alignment requirement inside the block is 0x1000 and we have
> __bss_start1 = .;
> .bss : {
> 	__bss_start2 = .;
> 	*(.bss.page_aligned)
> }
>
> Then you would see that:
> __bss_start1 equals 0xabcd
> __bss_start2 equals 0xb000
>
> Which may result in unexpected behaviour.
>
> The case I have in mind prevented the kernel from booting!
> So unless there are specific reasons (which should be documented)
> then always move the assignmnets inside the {} block.

I have no complaint with that.  I believe the symbols are absolute
simply because they were originally coded that way and the relocatable
kernel work on x86_64 didn't need them to change.

Eric
