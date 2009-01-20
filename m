Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbZATFcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbZATFcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 00:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbZATFcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 00:32:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55727 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbZATFcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 00:32:41 -0500
Message-ID: <497561E8.9070902@hathawaymix.org>
Date: Mon, 19 Jan 2009 22:32:24 -0700
From: Shane Hathaway <shane@hathawaymix.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
References: <49754AB5.3000701@hathawaymix.org> <20090120045959.GA18187@c2.user-mode-linux.org>
In-Reply-To: <20090120045959.GA18187@c2.user-mode-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-XM-SPF: eid=;;;mid=;;;hst=mx03.mta.xmission.com;;;ip=166.70.244.130;;;frm=shane@hathawaymix.org;;;spf=none
X-XM-DomainKey: sender_domain=hathawaymix.org;;;sender=shane@hathawaymix.org;;;status=no signature
X-SA-Exim-Connect-IP: 166.70.244.130
X-SA-Exim-Mail-From: shane@hathawaymix.org
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeff Dike <jdike@addtoit.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Patch] UML: spurious interrupt freezes guest
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx03.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Mon, Jan 19, 2009 at 08:53:25PM -0700, Shane Hathaway wrote:
>> A new instance of user mode linux that I created over the past couple of
>> days worked pretty well except that it had a habit of freezing after a
>> few minutes.  Every time it froze, the last message on the console was
>> either:
>>
>> spurious interrupt in ubd_handler, err = 4
> 
> What version and what's the workload?

I got the spurious interrupt with both Linux 2.6.28.1 and 2.6.27.12 as
guests.  The host runs 2.6.9-42.0.3.ELsmp.

I am putting OpenVPN and Asterisk inside the guest.  The guest is based
on Ubuntu 8.10.  The spurious interrupt happened more often when I
restricted the guest's RAM.  The processes in the guest normally consume
a total of about 20-24 MB of RAM.  I limited the guest's RAM to 48 MB
and gave it a 64 MB swap partition.  When I gave the guest only 32 MB,
the spurious interrupt seemed to happen more often.

The best way I found to trigger the spurious interrupt was to try to
"apt-get install" many packages at once.  The download would succeed,
but the guest would freeze partway through the install.

Shane
