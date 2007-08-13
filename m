Return-Path: <linux-kernel-owner+w=401wt.eu-S943636AbXHMQOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943636AbXHMQOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947529AbXHMO6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:58:11 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63177 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S946748AbXHMO6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:58:08 -0400
Date: Mon, 13 Aug 2007 16:57:27 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 04/23] Add cmpxchg_local to avr32
Message-ID: <20070813165727.2ad676d1@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070812145835.883846016@polymtl.ca>
References: <20070812145434.520271946@polymtl.ca>
	<20070812145835.883846016@polymtl.ca>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 10:54:38 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Use the new generic cmpxchg_local (disables interrupt) for 8, 16 and
> 64 bits cmpxchg_local. Use the __cmpxchg_u32 primitive for 32 bits
> cmpxchg_local.
> 
> Note that cmpxchg only uses the __cmpxchg_u32 or __cmpxchg_u64 and
> will cause a linker error if called with 8 or 16 bits argument.

Actually, you'll get a linker error if it's called with a 64-bit
argument too. But your patch doesn't use __cmpxchg_u64 so it's fine.

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Looks good to me. I suppose we _could_ implement 8- and 16-bit cmpxchg
using stcond, but I really doubt it's worth it.

Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
