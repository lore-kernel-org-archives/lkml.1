Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYKJV5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYKJV5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYKJV4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:56:55 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:36370 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYKJV4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:56:55 -0500
From: "Altobelli, David" <david.altobelli@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 10 Nov 2008 21:56:08 +0000
Subject: Disabling hpilo (see: sharing interrupt between PCI device)
Thread-Topic: Disabling hpilo (see: sharing interrupt between PCI device)
Thread-Index: AclDfyMJCwraMNYRTkWAhT7lp8s/Ew==
Message-ID: <92D64232F2316045B18937D5C9996B152252A03D21@GVW1144EXB.americas.hpqcorp.net>
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

I stumbled across this message, unfortunately I don't have the original to respond to.

http://lkml.org/lkml/2008/11/10/41

The problem mentioned, that unloading hpilo causes the iLO IRC kbd/mouse (uchi_hcd) to become non-functional, is not an IRQ issue.

iLO function 2 (hpilo) shares some global resources with function 4 (uhci_hcd), and when hpilo calls pci_disable_device(), the removal of busmastering (PCI_COMMAND_MASTER) means that the IRC kdb/mouse can't do what it needs to do.  Reloading hpilo will allow the IRC kdb/mouse to function correctly.

I've been struggling with what to do about this, removing the pci_disable_device() from hpilo will "fix" the problem, but that is clearly a hack.
