Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbXL3Nz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbXL3Nz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXL3NzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:55:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXL3NzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:55:17 -0500
Date: Sun, 30 Dec 2007 14:54:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Julia Lawall <julia@diku.dk>, tglx@linutronix.de, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/x86: Use offsetof
Message-ID: <20071230135458.GB21106@elte.hu>
References: <Pine.LNX.4.58.0712261712450.1185@pc-041.diku.dk> <20071226194718.GB8844@elf.ucw.cz> <4772F972.7070802@zytor.com> <20071227011712.GG27894@ZenIV.linux.org.uk> <4772FE1E.3040401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4772FE1E.3040401@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* H. Peter Anvin <hpa@zytor.com> wrote:

>>> The right way to do it is:
>>>
>>> 	memset(&info.vm86plus, 0, sizeof info.vm86plus);
>>
>> If it's just one field _and_ we don't have padding we want to zero out -
>> certainly...
>
> It is - [comments removed for clarity]:
>
> struct kernel_vm86_struct {
>         struct kernel_vm86_regs regs;
> #define VM86_TSS_ESP0 flags
>         unsigned long flags;
>         unsigned long screen_bitmap;
>         unsigned long cpu_type;
>         struct revectored_struct int_revectored;
>         struct revectored_struct int21_revectored;
>         struct vm86plus_info_struct vm86plus;
>         struct pt_regs *regs32;
> };

hm, i'm wondering why it was done in such a complex way. Clearing a 
struct field is always done via sizeof. Maybe we lost some alignment 
assumption somewhere along the line?

	Ingo
