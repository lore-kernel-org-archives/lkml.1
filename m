Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYB2GKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYB2GKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYB2GKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:10:45 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:53252 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYB2GKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:10:45 -0500
Date: Thu, 28 Feb 2008 23:10:23 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Pearson <devnull.port@googlemail.com>,
       Karol Kozimor <sziwan@hell.org.pl>, Julia Lawall <julia@diku.dk>,
       corentincj@iksaif.net, sziwan@users.sourceforge.net,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/9] drivers/acpi/asus_acpi.c: Correct use of ! and &
Message-ID: <20080229061023.GD19198@parisc-linux.org>
References: <Pine.LNX.4.64.0802262142120.18200@ask.diku.dk> <7C626792-02A6-4BE6-B5F2-D75899F3990C@hell.org.pl> <47C5ABFB.3050607@googlemail.com> <20080228215503.b942bb3c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228215503.b942bb3c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 09:55:03PM -0800, Andrew Morton wrote:
>  	if (invert)		/* invert target value */
> -		led_out = !led_out & 0x1;
> +		led_out = !led_out;
>  
>  	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))

But now you're writing 0xffffffff instead of 1.  I think the suggestion
of led_out ^= 1 was the correct one.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
