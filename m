Return-Path: <linux-kernel-owner+w=401wt.eu-S934451AbZDCPSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451AbZDCPSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764848AbZDCPSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:18:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:18839 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896AbZDCPR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:17:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,320,1235980800"; 
   d="scan'208";a="400095009"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: "Andrew J. Gallatin" <gallatin@myri.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 3 Apr 2009 16:17:38 +0100
Subject: RE: [RFC] ioat-dca: force I/OAT DCA when disabled in BIOS
Thread-Topic: [RFC] ioat-dca: force I/OAT DCA when disabled in BIOS
Thread-Index: Acmxgiq81nLAvvqTSfmuC6tujfraIQC7J3cQ
Message-ID: <129600E5E5FB004392DDC3FB599660D7910371D7@irsmsx504.ger.corp.intel.com>
References: <49D13FB1.9090701@inria.fr>
In-Reply-To: <49D13FB1.9090701@inria.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin wrote:
> Some machines (for instance Dell Poweredge servers) disable I/OAT DCA
> support in the BIOS without any way to reenable it.
> DCA may actually be enabled manually it in the processors' MSR and in
> upstream bridge registers. We have been doing this with a hacky userspace
> program, but we feel that the ioatdma driver may actually take care of it.
> 
> Here's a patch doing so, if the ioat_dca_force module parameter is set
> to 1 on load.
> 
> There are some things to improve:
> * Which pcidev should actually get DCA enabled? The patch below looks for
>   Intel upstream bridges. Do we need a check for pdev->is_pcie ? Or maybe
>   even look at pdev->pcie_type? It looks like the pcidev that need to be
>   configured on my machines are PCI_EXP_TYPE_ROOT_PORT, but I am not sure
>   it actually matters. Some Intel people will probably know how to fix this.
> * Any better name for #defin'ing bit #6 at offset 0x64 in the config-space
>   of these bridges?
> 
> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
> Signed-off-by: Andrew Gallatin <gallatin@myri.com>
> 

Hi Brice,

While this patch should work for some platforms (with I/OAT devices of IDs: 0x1a38, 0x360b, 0x65ff) it is not a platform generic solution.
Generally enabling DCA, like this dca_force() routine does, requires other settings including the tag_map which should be set by BIOS.
Thus it should be BIOS responsibility to prepare the whole required configuration for DCA.
For these reasons we don't want to include this solution in the ioatdma driver.
Please continue to use the userspace application instead.

Regards,
Maciej