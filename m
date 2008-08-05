Return-Path: <linux-kernel-owner+w=401wt.eu-S1762876AbYHEDnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762876AbYHEDnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbYHEDnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:43:13 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45068 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128AbYHEDnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:43:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	<m1iqukwjjg.fsf@frodo.ebiederm.org>
	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
	<m1wsj0nyx6.fsf@frodo.ebiederm.org>
	<86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>
	<m163qkjirc.fsf@frodo.ebiederm.org> <4896FCD0.8050006@sgi.com>
	<4897BD23.8060801@zytor.com>
Date: Mon, 04 Aug 2008 20:40:05 -0700
In-Reply-To: <4897BD23.8060801@zytor.com> (H. Peter Anvin's message of "Mon,
	04 Aug 2008 19:38:27 -0700")
Message-ID: <m1ej54nn8q.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1309]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Mike Travis wrote:
>>>
>>> So on my wish list is to stably encode the MSI interurrpt numbers.  And
>>> using a sparse irq address space I can.  As it only takes 28 bits to hold
>>> the complete bus + device + function + msi source [ 0-4095 ]
>>
>> Don't you need "domain" (node) in the bus:device:function:vector combination?
>> (Or [hack] use a lot bigger field for bus with the node encoded into it.)
>>
>
> You definitely need domain, and that blows the 32-bit limit quite out of the
> water.

Yes. Although when I dreamed it up it domain wasn't more then a twinkle in
someone's eye on x86.  I'm not certain it is much more than that now.

The interesting implication of this is that if you have the right hardware
and are absolutely loopy you can have more interrupt sources than can
be described in a 32bit unsigned int, and certainly more than any sane person
would allocate in a statically sized array.

Eric
