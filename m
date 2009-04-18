Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbZDRTxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbZDRTxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZDRTxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:53:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbZDRTxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:53:08 -0400
Message-ID: <49EA2F81.7030302@suse.com>
Date: Sat, 18 Apr 2009 15:52:33 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] IO-APIC + timer doesn't work!
References: <49E89D1B.7060800@suse.com> <49E9904A.5030201@web.de>
In-Reply-To: <49E9904A.5030201@web.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jan Kiszka wrote:
> Jeff Mahoney wrote:
>> Hi all -
>>
>> I saw this while booting 2.6.30-rc1, -rc2, and today's git, on one of
>> my development nodes. This output is with apic=debug. With noapic,
>> it still hung. Both outputs follow.
>>
>> git bisect leads to commit 8d6f0c8214928f7c5083dd54ecb69c5d615b516e,
>> but I'm not seeing anything obvious there. Backing just that change
>> out doesn't fix it.

[snip]

> Hmmmmm. That somehow reminds me of what I thought I had to fix in the
> HPET emulation of QEMU just recently [1] - because of 2.6.30-rc's behavior.
> 
> Could you try if writing 'delta' a second time makes any difference on
> that box?
> 
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 648b3a2..523d72b 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -324,6 +324,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
>  		       HPET_TN_SETVAL | HPET_TN_32BIT;
>  		hpet_writel(cfg, HPET_Tn_CFG(timer));
>  		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
> +		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
>  		hpet_start_counter();
>  		hpet_print_config();
>  		break;
> 

Thanks, Jan.

That fixed it for me.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknqL4EACgkQLPWxlyuTD7JGSQCfROvm+88YIifOzWNar0MOCs3F
s5QAoKDi1IKw0Qrk6dky3iQ+u3sF2eAh
=pgI6
-----END PGP SIGNATURE-----
