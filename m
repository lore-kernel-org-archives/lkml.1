Return-Path: <linux-kernel-owner+w=401wt.eu-S965419AbXDIUHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419AbXDIUHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXDIUHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:07:49 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:46811 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965452AbXDIUHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:07:48 -0400
Message-ID: <461A9D12.1060106@gmail.com>
Date: Mon, 09 Apr 2007 22:07:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
References: <460B6E4B.3060004@gmail.com> <200704022318.28451.rjw@sisk.pl> <46120449.7070302@gmail.com> <200704031250.07307.rjw@sisk.pl>
In-Reply-To: <200704031250.07307.rjw@sisk.pl>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> Thanks for testing.
[...]
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

I have bad news for you :(. I thought I had unpatched kernel, but it happens
in -rc6 too.

Next, when this occurs, kernel CPU1 is not brought up and next suspend hangs
on "Suspending consoles".

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
