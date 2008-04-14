Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbYDNO1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbYDNO1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761893AbYDNOYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:24:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:14747 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761880AbYDNOYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Az33apjJPSxeEkl58e4cEsQBZhtaDYbDc3tS9LQ5UxN3JeQuFkhfkwGFRuOige6O783AeZYFTfhIrnMpfOteKH2cB+wnrH0P1GhrAuQsFc/yYQ+zJsvo5FEhxnHhHwxEYzQmzqMfLQY6pNDppb9+kakIj1Lo4u4fnMWYrI7tT/8=
Message-ID: <4803690A.3080105@gmail.com>
Date: Mon, 14 Apr 2008 16:24:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
References: <12053582234100-git-send-email-yorksun@freescale.com>	<12053582231281-git-send-email-yorksun@freescale.com>	<47D8572C.8090501@gmail.com>	<47FFDBFF.1030809@gmail.com> <20080411221817.0b1eb414.akpm@linux-foundation.org> <48035E93.6070300@freescale.com> <48035F98.1020404@gmail.com> <48036001.10905@freescale.com> <4803620C.6020905@gmail.com> <48036649.6000409@freescale.com>
In-Reply-To: <48036649.6000409@freescale.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2008 04:12 PM, Timur Tabi wrote:
> Unfortunately, the author of the patch, York, is out this week, so I'll have to
> take care of this.  It'd be easier to modify rh_alloc() so that it doesn't
> sleep, so that's what I'm going to do.

Anyway, why do you need the spin lock there (and not mutex)? As I think you are 
still trying to avoid the problem instead of fixing it. Removing GFP_WAIT 
(fsl_diu_alloc) doesn't seem to me as mm friendly solution, especially if you 
allocate that much memory and you can sleep. But I might be wrong, you may need 
the spinlock...
