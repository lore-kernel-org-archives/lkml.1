Return-Path: <linux-kernel-owner+w=401wt.eu-S1764189AbXHIXfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764189AbXHIXfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbXHIXfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:35:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbXHIXfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:35:45 -0400
Message-ID: <46BBA4CB.7070009@redhat.com>
Date: Thu, 09 Aug 2007 19:35:39 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: i386 doublefault handler is broken with CONFIG_DEBUG_SPINLOCK
References: <46BB4599.2020900@redhat.com> <p73zm10egym.fsf@bingen.suse.de> <46BB5F9B.6050808@redhat.com> <20070809231618.GC1845@one.firstfloor.org>
In-Reply-To: <20070809231618.GC1845@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2007 07:16 PM, Andi Kleen wrote:
> 
> I tested it. Even on a box without spin lock debugging I get a hard
> hang after
> 
> double fault, gdt at c1404000 [255 bytes]
> 
> even though it should have printed the registers.
> So it looks like there is more broken in the DF handler than just
> this.

Looks like it just fails the ptr_ok() test:

#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + 0x1000000)

page_offset  c0000000
            + 1000000

           < c1404000

What should that be changed to, or is there some easier way to test that?
