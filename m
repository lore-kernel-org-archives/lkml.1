Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbYAYJv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbYAYJv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbYAYJvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:51:14 -0500
Received: from ns1.suse.de ([195.135.220.2]:45597 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbYAYJvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:51:12 -0500
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
Date: Fri, 25 Jan 2008 10:51:07 +0100
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <C3BF59DD.1B68F%Keir.Fraser@cl.cam.ac.uk>
In-Reply-To: <C3BF59DD.1B68F%Keir.Fraser@cl.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251051.08117.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Whether this a problem in light of Xen spurious faults depends on whether
> NMI handlers touch dynamically-allocated data. And if they do, it still
> depends on the exact scenario. If it is likely to be a problem, a Xen pv_op
> can flush the TLB on NMI entry, or we could have Xen do that implicitly
> before invoking the guest NMI handler.

For PV kernels it would probably be better to just implement a truly
nesting NMI trigger method instead of the one bit state of the real hardware.

Actually I'm not sure NMIs are really that useful for guests. Most things
done traditionally by NMIs are probably better done outside the guest
in a virtualized environment.

-Andi
