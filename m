Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYAEJoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYAEJoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYAEJoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:44:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44363 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYAEJoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:44:02 -0500
Date: Sat, 5 Jan 2008 09:44:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc oops in ip_fast_csum
Message-ID: <20080105094400.GH27894@ZenIV.linux.org.uk>
References: <200801041837.37650.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801041837.37650.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 06:37:36PM +0100, Mariusz Kozlowski wrote:
> Hello,
> 
>         This comes from the Linus latest linux-2.6 tree. Randomly happened.
> Can't reproduce that. More info below.

ip_fast_csum() called from raw_send_hdrinc() from raw_sendmsg() ran through
the page boundary into unmapped page...  Bloody odd, that, seeing that
we have checked iph->ihl * 4U <= length and had done
        err = memcpy_fromiovecend((void *)iph, from, 0, length);
before the
                iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
that had triggered that crap..
