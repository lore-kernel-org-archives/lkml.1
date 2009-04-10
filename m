Return-Path: <linux-kernel-owner+w=401wt.eu-S939522AbZDJSQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939522AbZDJSQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939013AbZDJSQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:16:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:43145 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763054AbZDJSQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:16:12 -0400
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1239386729.9282.3.camel@localhost.localdomain>
References: <1239385015.3169.15.camel@ht.satnam>
	 <20090410175545.GB16843@elf.ucw.cz>
	 <1239386729.9282.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 23:45:39 +0530
Message-Id: <1239387339.9282.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 23:35 +0530, Jaswinder Singh Rajput wrote:
> On Fri, 2009-04-10 at 19:55 +0200, Pavel Machek wrote:
> > On Fri 2009-04-10 23:06:55, Jaswinder Singh Rajput wrote:
> > > Impact: fix overflow
> > 
> > > Constant 0x123456789abcdef0 is so big for a long.
> > > So using saved_magic 0x12345678 for both 32 and 64 bit.
> > 
> > Have you tested the patch? I have feeling that this is tested from
> > assembly... Plus it is only set to long constant on 64-bit, so I don't
> > think you are fixing anything. And if your code is correct the
> > variable is write only...
> > 
> 
> I have tested this:
> 1.  CHECK   arch/x86/kernel/acpi/sleep.c
> arch/x86/kernel/acpi/sleep.c:107:16: warning: constant 0x123456789abcdef0 is so big it is long
> 
> 2. On 64 bit machine box:
> 	long l1;
> 
> 	l1 = 0x123456789abcdef0;
> 	printf("0x%16x : ", l1);
> 
> Output: 0x        9abcdef0
> 

OK  printf("0x%16llx : ", l1);
Output: 0x123456789abcdef0

--
JSR

