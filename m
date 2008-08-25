Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbYHYJal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbYHYJal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYHYJad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:30:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbYHYJad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:30:33 -0400
Date: Mon, 25 Aug 2008 11:30:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] Fix emergency_restart (sysrq-b) with kvm loaded on
	Intel hosts
Message-ID: <20080825093020.GA5617@elte.hu>
References: <1219655506-27418-1-git-send-email-avi@qumranet.com> <20080825091508.GC9114@elte.hu> <48B27AFE.3080704@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B27AFE.3080704@qumranet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> Ingo Molnar wrote:
>> * Avi Kivity <avi@qumranet.com> wrote:
>>
>>   
>>> Enabling Intel VT has the curious side effect whereby the INIT signal 
>>> is blocked.  Rather than comment on the wisdom of this side effect,  
>>> this patch adds an emergency restart reboot notifier, and modifies 
>>> the kvm reboot notifier to disable VT on emergency reboot.
>>>     
>>
>> looks good to me - i was bitten by that problem on a testbox.
>>   
>
> I'm a little worried about making emergency restart more complex.
>
> Another thing that worries me is that emergency_restart() doesn't 
> reset the box -- it sends INIT.  We could do better by using the ACPI 
> FADT reset register (hopefully that's connected to RESET).

reboot was always a bit fragile - i think we should only do that if we 
find a box where the FADT reset works better than the first-wave 
approaches we try.

> Which seems to be what we want? Maybe we should just try acpi_reboot() 
> before the other stuff.

perhaps in a separate commit, for v2.6.28 at the earliest.

	Ingo
