Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYKFPpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYKFPpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYKFPp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:45:29 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36500 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYKFPp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:45:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Eduardo Habkost <ehabkost@redhat.com>, Avi Kivity <avi@redhat.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
	<1225915018-6548-16-git-send-email-ehabkost@redhat.com>
	<20081106071445.GI15731@elte.hu> <20081106124031.GO5247@blackpad>
	<20081106143021.GD13023@elte.hu> <20081106150610.GA1644@elte.hu>
Date: Thu, 06 Nov 2008 07:41:01 -0800
In-Reply-To: <20081106150610.GA1644@elte.hu> (Ingo Molnar's message of "Thu, 6
	Nov 2008 16:06:10 +0100")
Message-ID: <m1mygczwtu.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0183]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > Andrey Borzenkov's patch, for example, adds a new DMI entry 
>> > because reboot=acpi breaks his keyboard (even without KVM, I 
>> > guess). Andrey, was that the case?
>> 
>> hm, IIRC the problem was KVM in his case too.
>
> actually, Andrey's problem seems to be unrelated. So i've queued up 
> the revert below in tip/x86/urgent for v2.6.28. Thanks guys!

If there are a number of problems with reboot and reset
I'm wondering if we should investigate using an
outb to port 0x92.  With the right bit set you can trigger
a toggle of the reset line on many motherboards.

Eric


