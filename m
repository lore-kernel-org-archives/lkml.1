Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZJVSAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZJVSAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 14:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZJVR77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 13:59:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60509 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754220AbZJVR76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 13:59:58 -0400
Date: Thu, 22 Oct 2009 19:01:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eugene Bordenkircher <eugebo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Ordering problem in serial_core.c
Message-ID: <20091022190142.0d7f35aa@lxorguk.ukuu.org.uk>
In-Reply-To: <fa2adfc3-986a-4db4-ad31-2613c478c097@g1g2000pra.googlegroups.com>
References: <cc845bea-0a4c-4958-b317-6b95120031a3@w37g2000prg.googlegroups.com>
	<fa2adfc3-986a-4db4-ad31-2613c478c097@g1g2000pra.googlegroups.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the line discipline is throttling the port when close is called, it
> tries to unthrottle the port which, in the case of soft flow, tries to
> send the XON character.  This doesn't work well since at this point
> the uart has been shutdown.

A rather more relevant question is why is the serial driver doing an
ldisc flush in the first place. 

> The simple reordering shown below will seems to fix the problem, but
> please comment if there are other side effects I am not seeing.

I don't see one offhand, and it looks a reasonable fix. I'll take a
deeper look next week but it might not be a bad idea for this to get put
into -next to see.
