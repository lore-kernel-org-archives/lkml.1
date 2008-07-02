Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYGBDME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYGBDME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760770AbYGBDLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:11:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49971 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077AbYGBDLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:11:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org>
	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>
	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>
	<486AE182.1020906@zytor.com>
Date: Tue, 01 Jul 2008 20:08:13 -0700
In-Reply-To: <486AE182.1020906@zytor.com> (H. Peter Anvin's message of "Tue,
	01 Jul 2008 19:01:38 -0700")
Message-ID: <m11w2dc7aa.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
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
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>
>> For i386 since virtual address space is precious and because there were
>> concerns about putting code in __pa we actually relocate the kernel symbols
>> during load right after decompression.  When we do relocations absolute
>> symbols are a killer.
>>
>
> Well, it means making it clear to the relocator if it should relocate those
> symbols or not.  Since IIRC we're doing "all or nothing" relocation, the
> relative offsets are always the same, even between sections.

Yes the relative offsets stay the same.  I don't remember if ld
generates useable relocations for what it figures are absolute
symbols.  I remember the solution was that anything that we wanted to
relocate we would make section relative, and anything else we would
leave absolute, and that those were easy things to do.

The nasty case is that occasionally ld has a bug where it turns section
relative symbols into global symbols if there is a section without data.
I don't recall us caring in those instances.

While interesting.  All of this is irrelevant until we start talking
unification between x86_63 and x86_64 as only x86_32 has this
restriction.

Eric
