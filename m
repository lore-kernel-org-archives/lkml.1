Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbYDLCbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbYDLCbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 22:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYDLCbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 22:31:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37028 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbYDLCbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 22:31:03 -0400
Date: Sat, 12 Apr 2008 03:31:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] suspicious code in frv/kernel/traps.c
Message-ID: <20080412023100.GN9785@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In insn_access_error():
        info.si_addr    = (void *) ((epcr0 & EPCR0_V) ? (epcr0 & EPCR0_PC) : __frame->pc);

In illegal_instruction():
        info.si_addr    = (void *) ((epcr0 & EPCR0_PC) ? (epcr0 & EPCR0_PC) : __frame->pc);

and with

#define EPCR0_V                 0x00000001      /* register content validity indicator */
#define EPCR0_PC                0xfffffffc      /* faulting instruction address */

it really smells like a braino in the latter...
