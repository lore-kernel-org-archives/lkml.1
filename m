Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbYCYSDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbYCYSDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYCYSDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:03:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47125 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbYCYSDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:03:07 -0400
Date: Tue, 25 Mar 2008 19:06:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jack Steiner <steiner@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080325180616.GX2170@one.firstfloor.org>
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org> <20080325175657.GA6262@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325175657.GA6262@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This should be probably factored properly (didn't Jeremy have smp_ops 
> > for this some time ago) so that even the default case is a call.
> 
> By factored, do you means something like:
> 	is_uv_legacy_system()
> 	is_us_non_unique_apicid_system()
> 	...
> 
> Or maybe:
> 	is_uv_system_type(x)   # where x is UV_NON_UNIQUE_APIC, etc

No instead of having lots of if (xyz_system) do_xyz_special()
go through smp_ops for the whole thing so that UV would just have a 
special smp_ops that has special implementions or wrappers. 

Oops I see smp_ops are currently only implemented
for 32bit. Ok do it only once smp_ops exist on 64bit too. 

-Andi
