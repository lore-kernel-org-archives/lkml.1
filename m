Return-Path: <linux-kernel-owner+w=401wt.eu-S964837AbXBYMLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837AbXBYMLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964831AbXBYMLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:11:13 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50710 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964837AbXBYMLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:11:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Zwane Mwaikambo <zwane@infradead.org>, Ashok Raj <ashok.raj@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] x86_64 irq: Safely cleanup an irq after moving it.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipt839.fsf_-_@ebiederm.dsl.xmission.com>
	<45E178A7.7090403@kolumbus.fi>
Date: Sun, 25 Feb 2007 05:09:48 -0700
In-Reply-To: <45E178A7.7090403@kolumbus.fi> (Mika =?iso-8859-1?Q?Penttil?=
 =?iso-8859-1?Q?=E4's?= message of "Sun,
	25 Feb 2007 13:53:11 +0200")
Message-ID: <m1ps7yphf7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Penttilä <mika.penttila@kolumbus.fi> writes:

> Eric W. Biederman wrote:
>>   * Vectors 0x20-0x2f are used for ISA interrupts.
>>   */
>> -#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR
>> +#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR + 0x10
>>  #define IRQ1_VECTOR		IRQ0_VECTOR + 1
>>  #define IRQ2_VECTOR		IRQ0_VECTOR + 2
>>  #define IRQ3_VECTOR		IRQ0_VECTOR + 3
>> @@ -82,7 +87,7 @@
>>
> I think we have a dependency in i8259.c that irq0 is mapped to vector 0x20.

We did, but I'm pretty certain I removed it when I introduced the
IRQ[0-15]_VECTOR defines.

One of my test machines seems to be delivering irq0 in EXTInt mode
with this patch applied (a bug of another flavor) so I don't think
there is a real issue here.

Eric
