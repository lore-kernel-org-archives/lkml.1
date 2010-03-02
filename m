Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0CBS0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:26:10 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:35828 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0CBS0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:26:07 -0500
X-IronPort-AV: E=Sophos;i="4.49,568,1262563200"; 
   d="scan'208";a="9747198"
Date: Tue, 2 Mar 2010 18:29:32 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH SERIES] enhanced PV on Xen HVM
Message-ID: <alpine.DEB.2.00.1003021817540.22259@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series is derived from an earlier version of Shen's "PV
extension of HVM" patch series.
It tries to achieve two goals:

- enable PV devices in Linux running in a Xen HVM domain;

- receive evtchns in place of interrupts to avoid expensive EOIs.

The main difference between the two patch series is the way the second
goals is achieved: in this patch series I am trying to reuse the same
code that is used in the Linux kernel to setup GSI to pirq mappings when
running as dom0.
In this case the GSIs that are being remapped correspond to emulated
interrupts, but Xen knows the difference and handles the two cases
separately.
It should be easy to use this mechanism also to map interrupts or MSIs
from pci passthrough devices with minimal changes to the Linux kernel.

The patch series consists of 5 patches, 1 for Xen and 4 for Linux; each
patch comes with a detailed description.

Any comment, critic or suggestion is very welcome.

Cheers,

Stefano
