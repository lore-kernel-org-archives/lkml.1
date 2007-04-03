Return-Path: <linux-kernel-owner+w=401wt.eu-S1422669AbXDCT7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422669AbXDCT7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422673AbXDCT7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:59:50 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:36802 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422672AbXDCT7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:59:49 -0400
Message-ID: <4612B225.7060003@gmail.com>
Date: Tue, 03 Apr 2007 21:59:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
References: <460B6E4B.3060004@gmail.com> <200704022318.28451.rjw@sisk.pl> <46120449.7070302@gmail.com> <200704031250.07307.rjw@sisk.pl>
In-Reply-To: <200704031250.07307.rjw@sisk.pl>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 03 Apr 2007 21:59:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> Okay, so I think the appended patch is needed.  Could you please revert the
[...]
> Index: linux-2.6.21-rc5/kernel/power/swsusp.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/kernel/power/swsusp.c
> +++ linux-2.6.21-rc5/kernel/power/swsusp.c
> @@ -229,13 +229,13 @@ int swsusp_shrink_memory(void)
>  		size += highmem_size;
>  		for_each_zone (zone)
>  			if (populated_zone(zone)) {
> +				tmp += snapshot_additional_pages(zone);
>  				if (is_highmem(zone)) {
>  					highmem_size -=
>  					zone_page_state(zone, NR_FREE_PAGES);
>  				} else {
>  					tmp -= zone_page_state(zone, NR_FREE_PAGES);
>  					tmp += zone->lowmem_reserve[ZONE_NORMAL];
> -					tmp += snapshot_additional_pages(zone);

This seems to work.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
