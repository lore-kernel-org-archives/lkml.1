Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbZJWLDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbZJWLDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 07:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZJWLDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 07:03:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZJWLDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 07:03:37 -0400
Date: Fri, 23 Oct 2009 13:03:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Erwan Velu <erwanaliasr1@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI
	table is present
Message-ID: <20091023110323.GC10071@elte.hu>
References: <4AE178AF.3010804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE178AF.3010804@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Erwan Velu <erwanaliasr1@gmail.com> wrote:

> When running the Linux Kernel, on some systems that doesn't have any DMI  
> table (like a Xen domU), some dmi_* calls can generates Warnings like :
>
>> / WARNING: at /usr/src/linux-2.6.29.1/drivers/firmware/dmi_scan.c:425/
>> / dmi_matches+0x7e/0x80()/
>> / dmi check: not initialized yet/

Empty DMI tables are common. What is not common is to call dmi_matches() 
before the DMI strings code has initialized.

> Some users reported this error : 
> http://lists.xensource.com/archives/html/xen-users/2009-04/msg00128.html 
> https://qa.mandriva.com/show_bug.cgi?id=54775

Looks like a Xen bug. DMI matching functions should be called after that 
code has initialized. The warning was added to catch such early calls.

Your patch works around that bug and the warning.

	Ingo
