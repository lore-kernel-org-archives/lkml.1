Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbYBMROd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbYBMROd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932369AbYBMRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:13:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103AbYBMRNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:13:51 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: print_vma_addr possible deadlock (was Re: Jeste jeden bug)
Date: Wed, 13 Feb 2008 18:13:46 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org
References: <c4e36d110802130841l591f20a4j32759821543b554c@mail.gmail.com> <Pine.LNX.4.64.0802131749460.30955@jikos.suse.cz> <Pine.LNX.4.64.0802131757360.7699@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0802131757360.7699@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131813.47136.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > in commit 03252919 you introduced print_vma_addr(), but this funcion for 
> > obvious reasons takes mmap_sem, so it is not safe to call it from atomic 
> > context (i.e. do_trap(), for example), which is behavior your patch 
> > introduced.

Ah yes -- this behaviour of int3 do_trap was always a source of bugs. I remember
fixing such things in this area several times (last time in the RT kernel), but 
I keep forgetting it. Sorry.

The correct fix is to run the int3 and debug handlers on the process stack 
when the fault originated from user space. Then they can run preemptive
and it's ok to schedule for the lock too.

I'll fix that tomorrow.

-Andi
