Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZDGFpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZDGFpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZDGFot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:44:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZDGFos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:44:48 -0400
Subject: Re: [GIT *] intel-iommu updates for 2.6.30 (second batch)
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090407053739.GA10500@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org>
	 <20090407053739.GA10500@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Apr 2009 22:44:05 -0700
Message-Id: <1239083045.22733.383.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 07:37 +0200, Ingo Molnar wrote:
> I suspect these bits are the ones that broke the upstream build:
> 
>  drivers/pci/dmar.c:47: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
> ‘__attribute__’ before ‘dmar_tbl_size’
>  drivers/pci/dmar.c:62: warning: ‘struct acpi_dmar_device_scope’
> declared inside parameter list
>  drivers/pci/dmar.c:62: warning: its scope is only this definition or
> declaration, which is probably not what you want

Yeah, <acpi/acpi.h> was being included implicitly for me, but certain
configs don't do that. Alexander Beregalov sent a patch for that, which
I added to my tree before Linus pulled it.

Commit 46f06b72378d3187f0d12f7a60d020676bfbf332 is the fix.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

