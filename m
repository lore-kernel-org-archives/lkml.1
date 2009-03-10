Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZCJVZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZCJVZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbZCJVZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:25:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59761 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbZCJVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:25:30 -0400
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49B5AD6A.2020101@goop.org> <49B5C12B.1020108@kernel.org>
	<20090310053721.GA25977@uranus.ravnborg.org>
	<m1bpsa6i72.fsf@fess.ebiederm.org> <49B6CB84.8060404@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 10 Mar 2009 14:25:18 -0700
In-Reply-To: <49B6CB84.8060404@kernel.org> (H. Peter Anvin's message of "Tue\, 10 Mar 2009 13\:20\:20 -0700")
Message-ID: <m1k56x2hq9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: hpa@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, mingo@elte.hu, jeremy@goop.org, yinghai@kernel.org, sam@ravnborg.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Absolute symbols in vmlinux_64.lds.S
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@kernel.org> writes:

> Eric W. Biederman wrote:
>> 
>> I have no complaint with that.  I believe the symbols are absolute
>> simply because they were originally coded that way and the relocatable
>> kernel work on x86_64 didn't need them to change.
>> 
>
> I have a vague memory of a bug in the x86-64 ld.

Oh.  I'm certain of it.  ld has all kinds of bugs off and on,
occasionally we are bound to run into a few of them.

ld bugs isn't the reason for using absolute linker symbols.  We use a
bunch of relative linker symbols as well.  All of the generic linker
scripts sections use them as well as a few of the x86_64 specific
sections.

For crazy things like 0 relative per cpu sections it might matter.
For the rest of the symbols absolute or relative simply
doesn't matter.

Is anyone interested in writing a patch testing it and changing things?

If not things should be good enough for now.

Eric
