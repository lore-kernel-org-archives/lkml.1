Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbXIYQVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbXIYQVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXIYQVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:21:11 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:60272 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752727AbXIYQVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:21:09 -0400
Message-ID: <46F93572.6070105@grupopie.com>
Date: Tue, 25 Sep 2007 17:21:06 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: eranian@hpl.hp.com
CC: linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com
Subject: Re: /proc/kallsyms and symbol size
References: <20070924205506.GC31899@frankl.hpl.hp.com>
In-Reply-To: <20070924205506.GC31899@frankl.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote:
> Hello,

Hi, Stephane

> Many monitoring tools use /proc/kallsyms to build a symbol table for the kernel.
> This technique has the advantage that it does not require root privileges, nor
> an up-to-date /boot/System.map, nor a decompressed kernel in /boot.
> 
> The problem is that /proc/kallsyms does not report the size of the symbols.
> Yet, the information is available in the kernel as it is used by functions such
> as __print_symbol(). Having the size is useful to correlate the address obtained
> is a sample with a symbol name. Most tools use an approximation which assumes
> symbols are contiguous to estimate the size.

That is actually what the kernel does internally, too. It does not keep 
the size of the symbol, but tries to guess it from the address of the 
next non-aliased symbol.

Since the addresses are sorted, this works fine most of the time. This 
is done to reduce the size used by the symbol table in the running kernel.

Just take a look at "get_symbol_pos" in kernel/kallsyms.c and 
"get_ksymbol" in kernel/module.c to see exactly how this is done

-- 
Paulo Marques - www.grupopie.com

"There cannot be a crisis today; my schedule is already full."
