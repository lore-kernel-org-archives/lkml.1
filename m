Return-Path: <linux-kernel-owner+w=401wt.eu-S932683AbXHXBDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbXHXBDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 21:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764958AbXHXBDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 21:03:32 -0400
Received: from gw.goop.org ([64.81.55.164]:56435 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764243AbXHXBDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 21:03:31 -0400
Message-ID: <46CE2E61.9010408@goop.org>
Date: Thu, 23 Aug 2007 18:03:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ingo Oeser <ioe-lkml@rameria.de>, lode leroy <lode_leroy@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memchr (trivial) optimization
References: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl> <200708230213.21332.ioe-lkml@rameria.de> <20070824001351.GA20266@waste.org>
In-Reply-To: <20070824001351.GA20266@waste.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
>   6e:   38 08                   cmp    %cl,(%eax)
>   70:   74 07                   je     79 <memchr3+0x1b>
>   72:   40                      inc    %eax
>   
It's a bit gross that the compiler is using inc here rather than lea or
add, but still...

Er, something's spending 30% of its time in memchr?  This is not the
code to fix.

    J
