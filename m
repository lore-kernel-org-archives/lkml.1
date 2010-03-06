Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0CFVdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:33:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab0CFVdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:33:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Q] How to tell we're using the KMS (during suspend/resume) outside the graphics driver
Date: Sat, 6 Mar 2010 22:36:09 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003062236.09801.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For at least two reasons it would be beneficial for some code outisde the
graphics driver(s) to know if the KMS are used.

First, in the non-KMS (ie. UMS) case we probably wouldn't want to call
acpi_video_resume(), because that has a potential to mess up with the GPU
(it actually is known to do that on at least one system).

Second, in the KMS case, we'd be able to skip the kernel VT switch, because
the KMS driver uses its own framebuffer anyway.

So, is there any reasonable way to check that from the outside of the graphics
driver?  It should be general enough to cover the cases when there are two
graphics adapters with different drivers in the system and so forth.

Rafael
