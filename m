Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbXLRRpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbXLRRpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbXLRRpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:45:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:62203 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbXLRRpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:45:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QVNdTiFIBmiz829uNGYaRM1DEYPsU1PG0h3N6JSTpQ1nRjdz0q/DSN5DTxLMnxvnVhOp0ye9AoGOswnfj4pg0tfNhGfQmcuEutM36+pAFvlMzGjTbh0qtg1xQQbonEBXvo9m1OdOhd2RQvbmmVmr46LCN9IkbX8zuPKGVYInsKc=
Message-ID: <5caa9b870712180945o17c797f7rb00a1b0d3fc12fc6@mail.gmail.com>
Date: Tue, 18 Dec 2007 17:45:45 +0000
From: "Steve Davies" <davies147@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: VIA Velocity and 802.1q VLAN support
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After a significant amout of archive searching, and code tweaking, I
am giving up and asking the list :)

I have a number of EPIA boards which need to operate in a mixed
tagged-VLAN and untagged-interface environment using their onboard
VIA-Velocity NICs. I am running a Debian ETCH 2.6.18 kernel, but have
managed to backport the latest 2.6.24-rc5 via-velocity driver fairly
simply. Sadly this does not seem to fix the problem.

Having added some debug kprintf, it appears as if the hardware VLAN
support is never enabled in this driver (vptr->vlgrp == NULL at all
times). I added a velocity_vlan_rx_register method, and enabled the
NETIF_F_HW_VLAN_RX feature, which did start to cause the appropriate
NIC registers to be set, but this simply stopped the inbound data
working entirely if a tagged vlan was created.

It manages to send packets both on the correct (tagged) vlan, and on
the untagged interface. The stock driver also receives packets on the
untagged interface okay, but inbound tagged packets never seem to make
it into the net subsystem.

I assume that the NIC is not allowing tagged packets into the driver
due to its built-in hardware acceleration/filtering :(

Is it inappropriate to beg for help and suggestions?

Thanks,
Steve
