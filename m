Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZLBKJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZLBKJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZLBKJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:09:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59023 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZLBKJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:09:57 -0500
Date: Wed, 2 Dec 2009 11:09:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH -tip] x86: reboot_fixup_32.c add missing pci_dev_put
Message-ID: <20091202100928.GE22654@elte.hu>
References: <1259291762-17735-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259291762-17735-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiaotian Feng <dfeng@redhat.com> wrote:

> pci_get_device increments reference count to the found pci device, 
> that should be decremented using pci_dev_put.

> +++ b/arch/x86/kernel/reboot_fixups_32.c
> @@ -80,6 +80,7 @@ void mach_reboot_fixups(void)
>  			continue;
>  
>  		cur->reboot_fixup(dev);
> +		pci_dev_put(dev);

Does this matter in practice? We are about to reboot. (but if it's 
cleaner to do it like this or if there's some real bug fixed by this 
then please spell it out in the changelog.)

	Ingo
