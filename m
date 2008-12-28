Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYL1TRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYL1TRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 14:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYL1TRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 14:17:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49330 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYL1TRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 14:17:35 -0500
Date: Sun, 28 Dec 2008 20:30:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] Remove interrupt stack table usage from x86_64 kernel
Message-ID: <20081228193046.GE496@one.firstfloor.org>
References: <1230238726-17506-1-git-send-email-avi@redhat.com> <87vdt5vfxc.fsf@basil.nowhere.org> <4956A0B1.1060908@redhat.com> <20081227224029.GB496@one.firstfloor.org> <49573FE7.9090802@redhat.com> <20081228131605.GC496@one.firstfloor.org> <49578896.8030703@redhat.com> <20081228190840.GD496@one.firstfloor.org> <4957CE78.6030706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4957CE78.6030706@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One fatal problem is enough -- I don't thing that patch can be made to 
> work.  Pity since it did clean up some stuff.

Not sure that was true anyways.

> I would like however to speed up kvm.  Here's a plan:
> 
> 1. Add per-cpu IDT

You don't need that, do you?  Just two sets.

> 2. When switching to the guest TR (and other state), switch off IST use 
> in the current IDT
> 3. When switching away from the kvm task, restore the IST entries
> 
> per-cpu IDT would cost around 4K per cpu.  I propose to make it 
> kconfigurable, and have kvm select it.

If anything please make it runtime switchable and disable it on Intel
CPUs.

-Andi
-- 
ak@linux.intel.com
