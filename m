Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZLUBKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZLUBKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZLUBKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:10:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54903 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZLUBKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:10:39 -0500
Message-ID: <4B2ECB00.4060907@cn.fujitsu.com>
Date: Mon, 21 Dec 2009 09:10:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
Subject: Re: [PATCH] new kfifo API v.08 (fixed)
References: <1261303696.18283.22.camel@wall-e>
In-Reply-To: <1261303696.18283.22.camel@wall-e>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold wrote:
> This is a complete rewrite of the new kfifo API, which is now really
> generic. The API is still stable. 
> 
> There are different types of a fifo which can not handled in C without a
> lot of overhead. So i decided to write the API as a set of macros, which 
> is the only way to do a kind of template meta programming without c++. 
> This macros handles the different types of fifos in a transparent way.
> 
> There are a lot of benefits:
> 
> - Compile time handling of the different fifo types
> - Performance (a save put or get of an integer does only generate 9 assembly
>   instructions on a x86) 
> - Type save
> - Cleaner interface, the additional kfifo_..._rec() functions are gone
> - Easier to use
> - Less error prone
> - Smaller footprint
> - Different types of fifos: it is now possible to define a int fifo or
>   any other type. See below for an example.
> - The size of the record field will be now detected at compile time
> - No need of creating a hidden variable, like in DEFINE_KFIFO
> 
> The API has not been change, but there are now real in place fifos
> where the data space is a part of the structure. There is no need for an
> extra indirection to the access the data and also no size field, because
> the size of the fifo can be determinate with sizeof. This kind of fifo
> does only need 8 bytes plus the fifo space.
> 
> The dynamic assigned or allocated fifos still needs 16 byte plus the 
> fifo space and does also creates more code.
> 
> Most of the macros code will be optimized away and does only generate a 
> function call.  Only the really the small ones generates inline code. The 
> overall size is half of the size of the previous implementation.
> 
> Additional you can now create fifos for any data type, not only the
> "unsigned char" byte streamed fifos.
> 
> There is also a new kfifo_put and kfifo_get function, to handle a single
> element in a fifo.
> 
> Here is a small example how to use it:
> 
> Example 1: an integer fifo
> 

Why don't you put those examples into samples/kfifo/ ?

