Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYCKVCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYCKVCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYCKVCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:02:37 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:26701 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbYCKVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:02:36 -0400
X-Belgacom-Dynamic: yes
Date: Tue, 11 Mar 2008 22:02:32 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Oliver Schuster <olivers137@aol.com>, Andrew Paprocki <andrew@ishiboo.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] v2.5.25-rc patches
Message-ID: <20080311210232.GE7505@infomag.infomag.iguana.be>
References: <20080310201419.GA7623@infomag.infomag.iguana.be> <47D6CC23.5020202@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D6CC23.5020202@aol.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

> this patch can cause serious problems in the case, that someone use it 
> with an it8712 rev. 8 and above.
...
> Your patch changes it8712f_wdt.c in function t8712f_wdt_update_margin():
> 
> >-	superio_outb((margin > 255) ? (margin / 60) : margin, WDT_TIMEOUT);
> >+	if (revision >= 0x08)
> >+		superio_outw(units, WDT_TIMEOUT);
> >+	else
> >+		superio_outb(units, WDT_TIMEOUT);
> 
> but here you can't use superio_outw, because the bytes are swapped 
> --historical reason.
> 
> I suggest to substitute
> 	superio_outw(units, WDT_TIMEOUT);
> with
> 	superio_outb(units >> 8, WDT_TIMEOUT + 1);
> 	superio_outb(units, WDT_TIMEOUT);
> 

Can you keep "Andrew Paprocki" <andrew@ishiboo.com> in the loop?
Can you also create a patch and test it together with Andrew?
We need to make sure that we fix this before 2.6.25 is there.

Thanks,
Wim.

