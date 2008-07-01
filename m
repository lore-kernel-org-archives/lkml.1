Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbYGAVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbYGAVvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYGAVvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:51:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43418 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYGAVve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:51:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>
	<485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org>
	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>
	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
	<874p79tils.fsf@basil.nowhere.org>
Date: Tue, 01 Jul 2008 14:42:29 -0700
In-Reply-To: <874p79tils.fsf@basil.nowhere.org> (Andi Kleen's message of "Tue,
	01 Jul 2008 23:11:43 +0200")
Message-ID: <m1iqvpffi2.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
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

Andi Kleen <andi@firstfloor.org> writes:

> ebiederm@xmission.com (Eric W. Biederman) writes:
>>
>> Has anyone investigated using the technique gcc uses for thread local storage?
>
> I investigated a long time ago (given when the binutils/gcc support
> was much more primitive) and my conclusion back then was that doing 
> the same for kernel module (negative addresses) would need 
> new relocation types.  And the pain of a binutils change didn't
> seem worth it.

Thanks.  That does seem to be the fly in the ointment of using the
builtin linker support.  The kernel lives at negative addresses which
is necessary but weird.

If the @tpoff relocation doesn't work for us we clearly can't use
the support.  I will have to look and see if usable relocation types
are generated from @tpoff.

Eric

