Return-Path: <linux-kernel-owner+w=401wt.eu-S934507AbZDINEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507AbZDINEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761087AbZDINEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:04:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:35153 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbZDINEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:04:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,160,1239001200"; 
   d="scan'208";a="446464252"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: "Andrew J. Gallatin" <gallatin@myri.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Thu, 9 Apr 2009 14:03:53 +0100
Subject: RE: [RFC] ioat-dca: force I/OAT DCA when disabled in BIOS
Thread-Topic: [RFC] ioat-dca: force I/OAT DCA when disabled in BIOS
Thread-Index: Acm0g3F77LlqnQlUSQi/sDcN56STbgEjruhg
Message-ID: <129600E5E5FB004392DDC3FB599660D791087894@irsmsx504.ger.corp.intel.com>
References: <49D13FB1.9090701@inria.fr>
 <129600E5E5FB004392DDC3FB599660D7910371D7@irsmsx504.ger.corp.intel.com>
 <49D64A42.9080304@inria.fr>
In-Reply-To: <49D64A42.9080304@inria.fr>
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
>> While this patch should work for some platforms (with I/OAT devices of IDs: 0x1a38, 0x360b,
>> 0x65ff) it is not a platform generic solution. Generally enabling DCA, like this dca_force()
>> routine does, requires other settings including the tag_map which should be set by BIOS. Thus
>> it should be BIOS responsibility to prepare the whole required configuration for DCA. 
> 
> Well, that's exactly the reason why the patch only enforces DCA when
> ioat_dca_force=1 is given. We obviously don't want to tweak registers
> like this by default, unless the admin knows what he is doing.

As we can't guarantee that dca_force() should work on all platforms,
we can't accept adding this functionality as a part of the driver - even if it's disbled by default.
If an admin wishes to take a chance he can use the userspace program.

> Having to run a custom script is really annoying for many Dell machine
> users where the tag_map is already correctly set by the BIOS. And you
> have to make sure that the script runs before ioatdma is loaded (which
> means you cannot built ioatdma inside the kernel, by the way).
> 
> By the way, do you have some ideas about how to filter bridges better?
> Maybe somebody at Intel has a whitelist of intel bridges that could be
> involved here?

What I found is that the list will be all root ports for the 5000-series chipset (Blackford),
5100-series chipset (San Clemente), 7300 chipset (Caneland).
The register does not exist for 5400 chipset (Seaburg).

Regards,
Maciej