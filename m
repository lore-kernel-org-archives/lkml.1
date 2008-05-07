Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbYEGWW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbYEGWW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbYEGWWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:22:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:45991 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbYEGWWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vy+xi9pqj+taiIt8Xht+q6PbIbDQ04bRO5KA0s6adQmAAYt4BkUYIHJpKEEyV8Uh2rmMnYOZv7j63W0wOLn7RWmuPRoMRumbfJitn11GY01h0/JlwhOopwghEtvInUBc5bst3UxrtSdARuxVVE/OJFFXrQgnb1o8u4oGOqYNOck=
Message-ID: <86802c440805071522r424b2011v7c0d852db4c4abfd@mail.gmail.com>
Date: Wed, 7 May 2008 15:22:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Adrian Bunk" <bunk@kernel.org>,
       "Rene Herman" <rene.herman@keyaccess.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
In-Reply-To: <20080507221435.GH18516@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48210A71.1060409@keyaccess.nl>
	 <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	 <20080507124650.GD29935@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
	 <20080507212343.GB14951@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de>
	 <20080507221435.GH18516@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 3:14 PM, Pavel Machek <pavel@suse.cz> wrote:
>  3) copy&paste code remained in the patch

i thought to keep the stub so could add more other stuff in the switch
like 64 bit

        clear_cpu_cap(c, X86_FEATURE_PAT);

        switch (c->x86_vendor) {
        case X86_VENDOR_AMD:
                early_init_amd(c);
                if (c->x86 >= 0xf && c->x86 <= 0x11)
                        set_cpu_cap(c, X86_FEATURE_PAT);
                break;
        case X86_VENDOR_INTEL:
                early_init_intel(c);
                if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
                        set_cpu_cap(c, X86_FEATURE_PAT);
                break;
        case X86_VENDOR_CENTAUR:
                early_init_centaur(c);
                break;
        }

YH
