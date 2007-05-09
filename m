Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbXEIMdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbXEIMdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbXEIMdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:33:12 -0400
Received: from ozlabs.org ([203.10.76.45]:54897 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXEIMdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:33:11 -0400
Subject: Re: [patch 2/9] lguest: the guest code
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org, ak@suse.de,
       jeremy@goop.org
In-Reply-To: <84144f020705090513q28784b69sd91cd2490514d44c@mail.gmail.com>
References: <200705090951.l499pYBV020391@shell0.pdx.osdl.net>
	 <84144f020705090316o5e3b6d89r74638ec8e4d396d4@mail.gmail.com>
	 <1178711957.7286.87.camel@localhost.localdomain>
	 <84144f020705090513q28784b69sd91cd2490514d44c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 09 May 2007 22:32:53 +1000
Message-Id: <1178713973.7286.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 15:13 +0300, Pekka Enberg wrote:
> Hi Rusty,
> 
> On 5/9/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >         Hmm, where would the error go?
> 
> Let it propagate: scan_devices -> lguest_bus_init -> do_initcalls. We
> probably don't want to panic() if bus_register and device_register
> fail there either.

Hi Pekka,

	Hey, thanks, I didn't realize that do_initcalls() now takes some note
when an initcall fails.  But I'm pretty sure a local error message is
more informative than "initcall at 0xc0123408: returned with error code
2" etc.

	And I agree about the panic: bus_register and device_register should
panic for us if they fail this early in boot.  But I don't think they
do...

Thanks,
Rusty.

