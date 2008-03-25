Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbYCYWEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbYCYWEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758678AbYCYWD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:03:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46795 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757760AbYCYWD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:03:56 -0400
Date: Tue, 25 Mar 2008 21:47:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: What if a TLB flush needed to sleep?
Message-ID: <20080325214725.3d707445@core>
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	down(&ptcg_sem);
> 	... execute ptc.g
> 	up(&ptcg_sem);

That will dig you a nice large hole for real time to fall into. If you
want to do rt nicely you want to avoid semaphores and the corresponding
lack of ability to fix priority inversions.

> 2) Is it feasible to rearrange the MM code so that we don't
> hold any locks while doing a TLB flush?  Or should I implement
> some sort of spin_only_semaphore?

Better to keep ia64 perversions in the IA64 code whenever possible and
lower risk for everyone else.

Alan

