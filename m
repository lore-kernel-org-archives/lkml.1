Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYGUXuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYGUXuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 19:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYGUXuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 19:50:04 -0400
Received: from gw.goop.org ([64.81.55.164]:33956 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYGUXuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 19:50:03 -0400
Message-ID: <4885209E.8050003@goop.org>
Date: Mon, 21 Jul 2008 16:49:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark McLoughlin <markmc@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] fix sysenter for 32-on-64 processes
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a little two-part patch series which fixes 32-on-64 syscalls 
using sysenter.

The first is a difference in ordering in arch_setup(); the 64-bit code 
was calling early_init_cpu() way too late.  Moving it earlier, to the 
same place as the 32-bit code, works for me, but I wonder if it might 
cause problems with other configurations.  Certainly it makes logical 
sense that both architectures do the same cpu setup at the same place.

The other fix is an outright Xen-specific bug, which resulted in 
usermode registers being trashed as a result of an over-enthusiastic use 
of sysret.

Both patches are .27 material, but I expect the arch_setup() change 
needs to cooking before being comfortable with it.

Thanks,
    J
