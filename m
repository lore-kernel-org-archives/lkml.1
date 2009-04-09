Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZDIFho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZDIFho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZDIFhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:37:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58060
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbZDIFhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:37:31 -0400
Date: Wed, 08 Apr 2009 22:37:19 -0700 (PDT)
Message-Id: <20090408.223719.61587584.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/12]: Sparc64 dynamic per-cpu support.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set converts sparc64 over to use the dynamic per-cpu stuff.

Most of the work is the boring task of getting rid of the special
"real_setup_per_cpu_areas()" sparc64 uses to setup the per-cpu areas
before bootmem is available.  We needed to do this because we
initialized the cpu possible map at the same time as the stuff stored
in the per-cpu cpu_data array.

So we split those tasks up.  Otherwise we wouldn't be able to convert
to dynamic per-cpu because that stuff requires that bootmem and the
page structs are ready to use.

For now I'm using the draconian unoptimized x86 NUMA remap scheme.  I
really want to do this better because it is insanely suboptimal on
Niagara chips where in some cases 8 cpus share the same physical TLB.

This is against Linus's current tree and it's also in sparc-next-2.6
