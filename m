Return-Path: <linux-kernel-owner+w=401wt.eu-S1764265AbYA3TIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764265AbYA3TIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYA3THw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:07:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbYA3THv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:07:51 -0500
From: Andi Kleen <ak@suse.de>
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: PATCH] x86_64: make bootmap_start page align v4
Date: Wed, 30 Jan 2008 20:08:32 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200801291113.35974.yinghai.lu@sun.com> <200801291928.13927.yinghai.lu@sun.com> <200801301051.08485.yinghai.lu@sun.com>
In-Reply-To: <200801301051.08485.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801302008.32811.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	/*
> +	 * when you have 64g or 128g ram, bootmap will be pushed after bss
> +	 * section, the bootmap we get from early_node_mem via find_e820_area
> +	 * is not page aligned, we need to round it up to  make sure bootmap
> +	 * is not overlapped with bss section
> +	 */
> +	bootmap_start = round_up(bootmap_start, PAGE_SIZE);

The better solution would be to PAGE_ALIGN() the addresses
in bad_addr(). Or better fix it that no such alignment is needed to not 
get conflicts. 

-Andi
