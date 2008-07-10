Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYGJVcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYGJVcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYGJVcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:32:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50816 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYGJVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:32:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>
	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>
	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>
	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>
	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>
	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org>
	<487639ED.7000502@zytor.com> <48763CA6.9030802@linux-foundation.org>
	<487647EF.5010609@goop.org> <48764A01.1070402@linux-foundation.org>
	<48764C7C.5010309@goop.org> <48767692.4080504@linux-foundation.org>
	<487677F0.4000404@goop.org> <4876799B.7010204@linux-foundation.org>
Date: Thu, 10 Jul 2008 14:22:18 -0700
In-Reply-To: <4876799B.7010204@linux-foundation.org> (Christoph Lameter's
	message of "Thu, 10 Jul 2008 16:05:31 -0500")
Message-ID: <m14p6xph85.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Lameter <cl@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3581]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> Jeremy Fitzhardinge wrote:
>
>> Percpu on i386 hasn't been a point of discussion.  It works fine, and
>> has been working fine for a long time.  The same mechanism would work
>> fine on x86-64.  Its only "issue" is that it doesn't support the broken
>> gcc abi for stack-protector.
>
> Well that is one thing and then the scaling issues, and the support of the new
> cpu allocator, new arch independent cpu operations etc.
>
>> The problem is all zero-based percpu on x86-64.
>
> The zero based stuff will enable a lot of things. Please have a look at the
> cpu_alloc patchsets.

Christoph again.  The reason we are balking at the zero based percpu
area is NOT because it is zero based.  It is because systems with it
patched in don't work reliably.

The bottom line is if the tools don't support a clever idea we can't use it.

Hopefully the problem can be root caused and we can use a zero based percpu area.
There are several ways we can achieve that.

Further any design that depends on a zero based percpu can work with a contiguous percpu
with an offset so we should not be breaking whatever design you have for the percpu
allocator.

Eric
