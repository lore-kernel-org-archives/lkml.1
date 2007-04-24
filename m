Return-Path: <linux-kernel-owner+w=401wt.eu-S1422797AbXDXR2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422797AbXDXR2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422800AbXDXR2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:28:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422797AbXDXR2O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:28:14 -0400
Date: Tue, 24 Apr 2007 10:27:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch v2] Fixes and cleanups for earlyprintk aka boot console.
Message-Id: <20070424102700.c58f8a6d.akpm@linux-foundation.org>
In-Reply-To: <462E0E60.5080907@redhat.com>
References: <20070315154638.944768000@suse.de>
	<20070423234240.29427438.akpm@linux-foundation.org>
	<462E0E60.5080907@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 16:04:16 +0200 Gerd Hoffmann <kraxel@redhat.com> wrote:

> > I get this, across netconsole:
> > 
> > [17179569.184000] console handover: boot [earlyvga_f_0] -> real [tty0]
> > 
> > wanna take a look at why there's cruft in bootconsole->name please?
> 
> -EFULL ;)
> 
> "earlyvga" is 8 chars.  struct console->name is char[8].  No space left 
> for the trailing ´\0´, the cruft comes from the next field (write 
> function pointer).  Obviously nobody ever printed the early console 
> names before.

doh.

> Hmm.  We can make the names shorter.  We can make the name field longer 
> (probably 16, it ends up taking that much anyway due to aligments at 
> least on 64bit).  This looks best to me.  We could also use 
> printk("%.8s",name) to make printk stop after 8 chars, but I somehow 
> don't like hardcoding the length like this ...
> 

yup, making it 16 sounds simplest.  I'll do the patch, thanks.
