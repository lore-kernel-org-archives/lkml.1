Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZDGFns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZDGFns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZDGFnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:43:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZDGFnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:43:39 -0400
Date: Tue, 7 Apr 2009 07:42:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] intel-iommu updates for 2.6.30 (second batch)
Message-ID: <20090407054249.GA25772@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org> <20090407053739.GA10500@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090407053739.GA10500@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> I suspect these bits are the ones that broke the upstream build:
> 
>  drivers/pci/dmar.c:47: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘dmar_tbl_size’
>  drivers/pci/dmar.c:62: warning: ‘struct acpi_dmar_device_scope’ declared inside parameter list
>  drivers/pci/dmar.c:62: warning: its scope is only this definition or declaration, which is probably not what you want
> 
> config attached.

hm, it breaks on all !ACPI configs AFAICS. The whole new code 
section you added to dmar.c depends on ACPI functionality.

Restricting DMAR to "depends on ACPI" in the Kconfig would probably 
work but is somewhat lame: this built fine with !ACPI before and if 
the hw ever gets discovered purely via the PCI space (it does not 
currently) we are hardwired to ACPI only. (adding more Kconfig 
dependencies also restricts testing, etc.)

	Ingo
