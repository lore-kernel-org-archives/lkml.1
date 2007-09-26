Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbXIZGvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbXIZGvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 02:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXIZGu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 02:50:56 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:52005 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXIZGuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 02:50:55 -0400
Date: Tue, 25 Sep 2007 23:50:47 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Paulo Marques <pmarques@grupopie.com>
Cc: linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com
Subject: Re: /proc/kallsyms and symbol size
Message-ID: <20070926065047.GE1993@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070924205506.GC31899@frankl.hpl.hp.com> <46F93572.6070105@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F93572.6070105@grupopie.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paulo,

On Tue, Sep 25, 2007 at 05:21:06PM +0100, Paulo Marques wrote:
> Stephane Eranian wrote:
> >Hello,
> 
> Hi, Stephane
> 
> >Many monitoring tools use /proc/kallsyms to build a symbol table for the 
> >kernel.
> >This technique has the advantage that it does not require root privileges, 
> >nor
> >an up-to-date /boot/System.map, nor a decompressed kernel in /boot.
> >
> >The problem is that /proc/kallsyms does not report the size of the symbols.
> >Yet, the information is available in the kernel as it is used by functions 
> >such as __print_symbol(). Having the size is useful to correlate the address 
> >obtained
> >is a sample with a symbol name. Most tools use an approximation which 
> >assumes
> >symbols are contiguous to estimate the size.
> 
> That is actually what the kernel does internally, too. It does not keep 
> the size of the symbol, but tries to guess it from the address of the 
> next non-aliased symbol.
> 
> Since the addresses are sorted, this works fine most of the time. This 
> is done to reduce the size used by the symbol table in the running kernel.
> 
> Just take a look at "get_symbol_pos" in kernel/kallsyms.c and 
> "get_ksymbol" in kernel/module.c to see exactly how this is done
> 
Ok. Then we cannot really do better. 

Also thank you for alerting me on the aliased symbols. I have modified
my user code to only keep the first symbol.

Thanks for you help.

-- 

-Stephane
