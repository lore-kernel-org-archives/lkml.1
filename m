Return-Path: <linux-kernel-owner+w=401wt.eu-S1764521AbYA3UQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbYA3UQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764726AbYA3UI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:08:59 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33777 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765768AbYA3UI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:08:58 -0500
Date: Wed, 30 Jan 2008 12:15:50 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: PATCH] x86_64: make bootmap_start page align v4
In-reply-to: <200801302008.32811.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801301215.51645.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <200801301051.08485.yinghai.lu@sun.com> <200801302008.32811.ak@suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008 11:08:32 am Andi Kleen wrote:
> 
> > +	/*
> > +	 * when you have 64g or 128g ram, bootmap will be pushed after bss
> > +	 * section, the bootmap we get from early_node_mem via find_e820_area
> > +	 * is not page aligned, we need to round it up to  make sure bootmap
> > +	 * is not overlapped with bss section
> > +	 */
> > +	bootmap_start = round_up(bootmap_start, PAGE_SIZE);
> 
> The better solution would be to PAGE_ALIGN() the addresses
> in bad_addr(). Or better fix it that no such alignment is needed to not 
> get conflicts. 

I don't think so, that is setup_node_bootmem's problem. 

it is supposed to round_up instead of just do PAGE_SHIFT...

other caller will just use the address instead change it page.

YH
