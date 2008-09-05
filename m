Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYIEPF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYIEPF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYIEPFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:05:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42978 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbYIEPFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:05:16 -0400
Date: Fri, 5 Sep 2008 17:08:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Bernd Schubert <bs@q-leap.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: frame unwinder patches
Message-ID: <20080905150833.GU18288@one.firstfloor.org>
References: <g9p3du$n95$1@ger.gmane.org> <200809051552.47929.bs@q-leap.de> <20080905071337.3373ab86@infradead.org> <200809051648.52767.bs@q-leap.de> <20080905075703.6041650e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905075703.6041650e@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> to be honest, on 64 bit the overhead is quite small (the extra
> instructions it adds are optimized for by the modern cpus that you use

The pipeline dependency stalls yes, the icache/decode overhead no.
Also CONFIG_FRAME_POINTER currently enables -fno-sibling-calls
which generates significantly worse code for a lot of common
kernel constructs.

> in the systems you're selling); on 32 bit the overhead is.. well a
> little bigger but not THAT much. yes it loses a register for the
> compiler to use, but no it's not a general purpose register, and with

%rbp is a general purpose register.  In fact it's even better
than a general purpose register because it has often shorter 
encoding than the other registers, but is as versatile.

> the register renaming that today's cpus do, I'd be surprised if you
> could see anything significant.

Even on modern CPUs you can measure it in macro benchmarks, at 
least that was the state last time that was investigated.
On older CPUs without the magic hardware it was even more
significant. Also there are even new CPUs like Atom which don't
have the magic hardware.

-Andi

