Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbZFJTGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbZFJTGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbZFJTGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:06:02 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:29383 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbZFJTGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:06:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAegL0pR9cDZ/2dsb2JhbADRJQiEBQU
Date: Wed, 10 Jun 2009 21:06:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Florian Fainelli <florian@openwrt.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, biblbroks@sezampro.rs
Subject: Re: add bcm47xx watchdog driver
Message-ID: <20090610190602.GL16090@infomag.iguana.be>
References: <4A282D98.6020004@free.fr> <20090605124813.d7666ed0.akpm@linux-foundation.org> <4A29805D.60205@free.fr> <200906081615.45889.florian@openwrt.org> <20090610171732.GI16090@infomag.iguana.be> <4A2FFFDA.6010807@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2FFFDA.6010807@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthieu,

>> +
>> +#define WDT_DEFAULT_TIME	30	/* seconds */
>> +#define WDT_MAX_TIME		255	/* seconds */
> Why have changed this from 256 to 255 ?

Since you use a timer to control the real watchdog, the wdt_time function is arbitraty anyway.
Most watchdog drivers use 0xFFFF. Since you only went to 256 it made more sense to have it as 0xFF which is 255.
We can make it 65535 also. 

>> +}
>> +
>> +static int bcm47xx_wdt_notify_sys(struct notifier_block *this,
>> +	nsigned long code, void *unused)
>        ^^^^
> Does this build ?

Nope. should be unsigned.

Kind regards,
Wim.

