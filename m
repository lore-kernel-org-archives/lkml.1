Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYJQGlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYJQGlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbYJQGlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:41:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYJQGll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:41:41 -0400
Message-ID: <48F832DB.2050502@zytor.com>
Date: Thu, 16 Oct 2008 23:38:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <48F409E9.3030501@zytor.com>	 <20081013.223811.174710738.davem@davemloft.net>	 <Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>	 <20081016.013850.85183428.davem@davemloft.net>	 <1224212533.7654.60.camel@pasglop> <1224212791.7654.63.camel@pasglop>	 <86802c440810162039v7c347888i34e26058b70f37d5@mail.gmail.com> <1224215192.7654.70.camel@pasglop>
In-Reply-To: <1224215192.7654.70.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> 
> With that patch, it will use just as many digits as necessary to display
> a given number. The question I'm asking in the comments is whether we
> want to instead use fixed digits with zero padding, and in that case,
> do we want a hook or something for archs to decide how many digits
> for IO vs. memory.
> 

Yes, and yes.

We want to pad to keep people from mistaking, say, c000000 from 
c0000000.  At least on x86, it also acts as a visual cue for the type of 
resource space, as people are used to seeing I/O ports as 16-bit numbers 
with four hexdigits, and 8- or 16-hexdigit numbers for memory addresses.

	-hpa
