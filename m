Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYHUM6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYHUM6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbYHUM6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:58:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36322 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbYHUM6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:58:32 -0400
Message-Id: <48AD82D5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 21 Aug 2008 13:59:33 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <robert.richter@amd.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: patch "x86: MOVE PCI IO ECS code to x86/pci" breaks CPU
	hotplug
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Converting __cpuinit functions called out of init_amd() (and similar others)
>to __init (and making them subject of xxx_initcall() handling isn't valid, as
>they would no longer be called for hot plugged CPUs.
>
>Further, since it's likely that in virtualized environments the MSR write
>would at best be ignored, I'd also recommend using the fault-safe
>accessors here *and* check that the bit actually got set before setting
>PCI_HAS_IO_ECS (one would obviously have to BUG() when hot-plugged
>CPUs fail to set the bit when those available at boot successfully did so).

Even worse - this would even try to access the MSR on non-AMD CPUs
(currently probably prevented just by the fact that only AMD ones use
family values of 0x10 or higher).

Jan

