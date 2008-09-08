Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYIHVIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYIHVIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 17:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYIHVI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 17:08:27 -0400
Received: from mail.vyatta.com ([216.93.170.194]:34691 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbYIHVI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 17:08:26 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.55
Date: Mon, 8 Sep 2008 14:08:24 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbarnes@virtuousgeek.org, bhutchings@solarflare.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI: vpd handle longer delays in access
Message-ID: <20080908140824.5ab3c7ca@extreme>
In-Reply-To: <20080908134025.9ac23a73.akpm@linux-foundation.org>
References: <20080904205636.130211023@vyatta.com>
	<20080904205718.543005986@vyatta.com>
	<20080908134025.9ac23a73.akpm@linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 13:40:25 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 04 Sep 2008 13:56:37 -0700
> Stephen Hemminger <shemminger@vyatta.com> wrote:
> 
> > Accessing the VPD area can take a long time.  The existing 
> > VPD access code fails consistently on my hardware. There are comments
> > in the SysKonnect vendor driver that it can take up to 13ms per word. 
> > 
> > Change the access routines to:
> >   * use a mutex rather than spinning with IRQ's disabled and lock held
> >   * have a longer timeout
> >   * call schedule while spinning to provide some responsivness
> 
> It doesn't call schedule() - it calls yield().
> 
> yield() is pretty notoriously badly behaved in the presence of lots of
> runnable tasks and there's been a general move to eradicate its
> in-kernel callsites.
> 
> An alternative would be nice.

What is a good way to say "i am polling for a while"?
