Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0BAR5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:57:53 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:26479 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab0BAR5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:57:51 -0500
Date: Mon, 1 Feb 2010 10:57:50 -0700
From: Alex Chiang <achiang@hp.com>
To: Chris Mason <chris.mason@oracle.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] set dock_station->flags to zero during dock_add
Message-ID: <20100201175750.GC28002@ldl.fc.hp.com>
References: <20100201163043.GA3240@think> <20100201173518.GA28002@ldl.fc.hp.com> <20100201174557.GB3240@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201174557.GB3240@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Mason <chris.mason@oracle.com>:
> On Mon, Feb 01, 2010 at 10:35:18AM -0700, Alex Chiang wrote:
> > Hi Chris,
> > 
> > Thanks for catching this. Seems better to just memset the stack
> > variable before we kmemdup it in platform_deivce_register_data().
> > 
> > How about this instead?
> 
> [ memset instead of explicitly setting flags to zero ]
> 
> I didn't do the memset because lower down we init every other field, but
> zeros are zeros really.

Sure, zeros are zeros. I chose memset in case the struct grows in
the future and someone else forgets to initialize members to
zero.

I'll let Len decide which patch to take, it doesn't much matter
to me.

If he takes yours...

Acked-by: Alex Chiang <achiang@hp.com>

> Looking at platform_device_register_data, you could even make
> ds static...now that is sure to break in small and subtle ways
> later on ;)

Ha, those are bugs that I don't have to have to fix in the
future. :)

cheers,
/ac
