Return-Path: <linux-kernel-owner+w=401wt.eu-S964812AbXBYMAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbXBYMAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964825AbXBYMAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:00:30 -0500
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:52252 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964812AbXBYMAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:00:30 -0500
Message-ID: <45E178A7.7090403@kolumbus.fi>
Date: Sun, 25 Feb 2007 13:53:11 +0200
From: =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Zwane Mwaikambo <zwane@infradead.org>, Ashok Raj <ashok.raj@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] x86_64 irq: Safely cleanup an irq after moving
 it.
References: <200701221116.13154.luigi.genoni@pirelli.com>	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>	<m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>	<m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>	<m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com>	<m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com> <m1lkipt839.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1lkipt839.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>   * Vectors 0x20-0x2f are used for ISA interrupts.
>   */
> -#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR
> +#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR + 0x10
>  #define IRQ1_VECTOR		IRQ0_VECTOR + 1
>  #define IRQ2_VECTOR		IRQ0_VECTOR + 2
>  #define IRQ3_VECTOR		IRQ0_VECTOR + 3
> @@ -82,7 +87,7 @@
>   
I think we have a dependency in i8259.c that irq0 is mapped to vector 0x20.

--Mika

