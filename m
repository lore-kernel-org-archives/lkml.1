Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbYF0KIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbYF0KIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 06:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYF0KIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 06:08:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49917 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbYF0KIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 06:08:12 -0400
Date: Fri, 27 Jun 2008 12:07:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 00/34] AMD IOMMU driver
Message-ID: <20080627100751.GA27822@elte.hu>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <20080627081807.GA6562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627081807.GA6562@elte.hu>
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


-tip testing found a build failure with:

arch/x86/kernel/amd_iommu_init.c:247: warning: 'struct acpi_table_header' declared inside parameter list
arch/x86/kernel/amd_iommu_init.c:247: warning: its scope is only this definition or declaration, which is probably not what you want
arch/x86/kernel/amd_iommu_init.c: In function 'find_last_devid_acpi':
arch/x86/kernel/amd_iommu_init.c:257: error: dereferencing pointer to incomplete type

  http://redhat.com/~mingo/misc/config-Fri_Jun_27_10_29_06_CEST_2008.bad

this is due to !CONFIG_ACPI.

since AMD IOMMU discovery depends on ACPI anyway, i've fixed this in the 
Kconfig space. (Eventually, if you want to make it directly discoverable 
via the PCI space in the future, you might want to fix this dependency.)

i've pushed out the fix below into -tip.

	Ingo
