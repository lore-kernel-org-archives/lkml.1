Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbXJYORJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbXJYORJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbXJYOQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:16:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43516 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193AbXJYOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:16:56 -0400
Date: Thu, 25 Oct 2007 07:13:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sami Farin <safari-kernel@safari.iki.fi>
Cc: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: x86: randomize brk() and RLIMIT_DATA
Message-ID: <20071025071324.2eac21d6@laptopd505.fenrus.org>
In-Reply-To: <20071025134124.wc44gdud7ixghfxv@m.safari.iki.fi>
References: <20071025134124.wc44gdud7ixghfxv@m.safari.iki.fi>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 16:41:24 +0300
Sami Farin <safari-kernel@safari.iki.fi> wrote:

> Would be neat if randomized brk and setrlimit(RLIMIT_DATA, ...)
> worked in a predictable way:

this isn't a valid case afaics; even on "traditional x86" (before we
changed the address space layout, or even today if you have an
unlimited stack rlimit) this isn't going to work. applications really
shouldn't use (s)brk() but malloc(); you have to be able to fall back
to mmap regardless of what you do.

> 
> $ gcc brk.c -fPIC -pie -m64;./a.out;./a.out;./a.out
> sbrk=0x7f721b815000 main=0x7f721af04860
> sbrk succeeded (brk=0x7f721b909240)
> sbrk=0x7fc3d77e2000 main=0x7fc3d66fa860
> sbrk failed: Cannot allocate memory (brk=0x7fc3d77e2000)
> sbrk=0x7f05b0615000 main=0x7f05af76b860
> sbrk failed: Cannot allocate memory (brk=0x7f05b0615000)
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
