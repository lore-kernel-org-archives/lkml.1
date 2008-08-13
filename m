Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYHMReI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYHMReI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYHMRd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:33:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:33576 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYHMRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=opbJg6QJg03c4I5OI58Qt3vjjuuPcJQJuD9w47B40K0I4HkfVPqqgWgUhG/W2N2/HB
         9iISJmHV6kQ2WZ2uaP6pZIY7Y0TseIA4mnpRaZqZSHbEOiM5cHQ1Pm+6Ir7MkfdXyZoh
         fusikzkax9n9Agp7zeJPAi6T3MeGES0tsKSTE=
Message-ID: <b6a2187b0808131033m25a7e147x98235a48abd3eb3c@mail.gmail.com>
Date: Thu, 14 Aug 2008 01:33:53 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "David Miller" <davem@davemloft.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <b6a2187b0808131010u7481f663n94d8e005b9dac2d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
	 <20080813141629.GD19397@elte.hu>
	 <b6a2187b0808131010u7481f663n94d8e005b9dac2d1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 1:10 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Wed, Aug 13, 2008 at 10:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>> btw., could you please check that v2.6.27-rc3 (or later) kernels boot
>> fine (with about 8 cpus) even if you have genericarch/bigsmp disabled,
>> and do not silently hang as it happened on your box before?
>
> With 16 CPUs, it still hangs, but now the console is showing the
> errors as intended.
> ... but it is supposed to hang?

I tried with just CONFIG_NR_CPUS=8 and this time it booted, but stange
thing is I only see 2 CPUs! To be more precise, it's without both
CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.

And when I tried to enable the CPUs, it complained about:

# cat cpu6/online
0
# echo 1 > cpu6/online
More than 8 CPUs detected - skipping them.
Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
-bash: echo: write error: Input/output error

Prior to the patch, the system booted with all 8 CPUs.

Again, if I enable both CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP,
I get all 16 CPUs.

Thanks,
Jeff.
