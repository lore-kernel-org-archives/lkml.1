Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYEMQtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYEMQtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYEMQtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:49:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:22359 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbYEMQtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:49:00 -0400
Message-ID: <a24804730805130949o32687f74id4fce833c3589641@mail.gmail.com>
Date: Tue, 13 May 2008 09:49:00 -0700
From: "Chris Peterson" <cpeterso@cpeterso.com>
To: linux-kernel@vger.kernel.org
Subject: network devices: to IRQF_SAMPLE_RANDOM or not to IRQF_SAMPLE_RANDOM?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should network devices be allowed to contribute entropy to /dev/random?

This issue has been discussed before, but does not seem to have been
settled: some net drivers [1] use IRQF_SAMPLE_RANDOM when calling
request_irq(), but the vast majority do not. It seems like all net
drivers should follow the same entropy paranoia policy (whether that
is all net drivers should use IRQF_SAMPLE_RANDOM, no net drivers, or a
compile-time option).

Robert Love wrote a patch that added such a compile-time option,
CONFIG_NET_RANDOM (though I believe he stopped maintaining it in
2004). [2]

chris

[1] net drivers that use IRQF_SAMPLE_RANDOM:

drivers/net/3c523.c
drivers/net/3c527.c
drivers/net/atlx/atl1.c
drivers/net/cris/eth_v10.c
drivers/net/ibmlana.c
drivers/net/macb.c
drivers/net/mv643xx_eth.c
drivers/net/netxen/netxen_nic_main.c
drivers/net/niu.c
drivers/net/qla3xxx.c
drivers/net/tg3.c
drivers/net/xen-netfront.c

[2] http://www.kernel.org/pub/linux/kernel/people/rml/netdev-random/
