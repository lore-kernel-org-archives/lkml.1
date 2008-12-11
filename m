Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYLKSMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYLKSMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 13:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYLKSMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 13:12:44 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:10000 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYLKSMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 13:12:43 -0500
Date: Thu, 11 Dec 2008 11:12:42 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: justin.chen@hp.com, linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] PCI Hotplug: acpiphp wants a 64-bit _SUN
Message-ID: <20081211181242.GD18309@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, justin.chen@hp.com,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

Here are two patches for acpiphp.

Although Willy's patch 27663c5855b10af9ec67bc7dfba001426ba21222
(ACPI: Change acpi_evaluate_integer to support 64-bit on 32-bit
kernels) is now in, the problem we were initially trying to fix
before discovering that patch still exists.

The problem is that on certain HP systems, the _SUN method does
utilize the full 64 bits. Declaring sun in struct acpiphp_slot as
a u32 leads to name collisions on our systems.

The first patch from Justin changes the declaration of sun to
unsigned long long. It has been tested and verified that it fixes
the name collision issue on our machines.

I also did a build test in a 32-bit x86 environment to make sure
we don't get any compiler warnings, and it was clean.

Please consider that patch for 2.6.28. It's late-breaking, but I
feel is low-risk.

The second patch is a mere whitespace patch. Since I was in the
file anyway, I figured I'd clean it up a bit.

[setting 'let c_space_errors=1' in a .vimrc shows all kinds of
wonderful stuff ;) ]

Thanks.

/ac

