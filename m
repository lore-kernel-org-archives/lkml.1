Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032007Ab0B1UKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:10:44 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47952 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031966Ab0B1UKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:10:42 -0500
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <m1pr3qcbk1.fsf@fess.ebiederm.org>
	<20100228195243.GA15976@ioremap.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Feb 2010 12:10:35 -0800
In-Reply-To: <20100228195243.GA15976@ioremap.net> (Evgeniy Polyakov's message of "Sun\, 28 Feb 2010 22\:52\:43 +0300")
Message-ID: <m1r5o5azpg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Evgeniy Polyakov <zbr@ioremap.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: Why does connector use a work queue???
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov <zbr@ioremap.net> writes:

> On Sat, Feb 27, 2010 at 06:57:02PM -0800, Eric W. Biederman (ebiederm@xmission.com) wrote:
>> These days netlink callbacks for messages happen in the context of the
>> process who sent the message.  Things like permission checks are much
>> more complicated if we don't use that process context.
>> 
>> I was looking at removing NETLINK_CB(skb).eff_cap but I discovered
>> that connected takes the netlink messages, them from their
>> perfectly good process context, and puts the into a workqueue
>> for reasons that are not apparent to me.
>
> Netlink was made synchronous rather recently and connector was not
> changed to take advantage of that. Previously it used work queue to
> postpone work processing into always-process context.

I suspected it was something like that but I want to be certain.

>> Unless I am misreading something we should just be able to remove the
>> work queues and greatly simplify the connector code.
>> 
>> Something like:
>
> Idea looks very good, thank you, but it misses structure changes
> to eliminate now unneded members.

Right. I didn't trust myself to write a patch that would rip out half
of the connector code until I understood what the constraints were.

Eric
