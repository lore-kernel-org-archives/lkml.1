Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbYENO62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbYENO62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYENO6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:58:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:21215 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbYENO6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=tfSQ01dEFMjKAtkTyprnsEPS1UzJMkgoTdMfhDbKr+DhhQSYYH0vYW8yH+aUVItBy3g63B7hemtrH9a2nZXTH9xw5RoLcc7oDTur7oQg+1DAq82zavka5KWm11QlbGktq7lmfqcLpHUWRFb7HGMVf3eH3SM/3kcwbIzl4haWpwM=
Date: Wed, 14 May 2008 18:58:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to
	`strlen'
Message-ID: <20080514145808.GC6902@cvg>
References: <Pine.LNX.4.64.0805140958400.5778@anakin> <jeprrpth5m.fsf@sykes.suse.de> <20080514141056.GB19909@cs181133002.pp.htv.fi> <jeabitt0xj.fsf@sykes.suse.de> <20080514144031.GA6902@cvg> <je63thszo6.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <je63thszo6.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andreas Schwab - Wed, May 14, 2008 at 04:55:37PM +0200]
| Cyrill Gorcunov <gorcunov@gmail.com> writes:
| 
| > I think it would help to see ..tmp_vmlinux1.cmd to ensure for inclusion
| > of lib/lib.a. strlen was there without my patch as Andreas already pointed,
| > I've just added strncat wich is coming from lib/string.o for this arch.
| 
| Actually the way strncat is used here is broken anyway, it does not
| prevent array overrun.  The third argument of strncat only limits the
| amount of characters copied, without taking into account the length of
| the string already in the buffer.  Consequently gcc has optimized the
| call to strncat into a simple call to strcat, since none of the copied
| strings are longer than sizeof(msgbuf).  This strcat call is then
| expanded to include a call to strlen.
| 
| So a better fix would probably be to make msgbuf big enough and use
| strcat instead.
| 
| Andreas.
| 
| -- 
| Andreas Schwab, SuSE Labs, schwab@suse.de
| SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
| PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
| "And now for something completely different."
| 

Thanks Andreas, I'll fix it.

		- Cyrill -
