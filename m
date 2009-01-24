Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbZAXWyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbZAXWyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 17:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZAXWy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 17:54:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60193 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZAXWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 17:54:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <497B9C13.4020802@s5r6.in-berlin.de>
Date: Sat, 24 Jan 2009 23:54:11 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Peter Hallberg <hallberg68@hotmail.com>
CC: arjan@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: EXTRA_VERSION in #if LINUX_VERSION_CODE >= KERNEL_VERSION(x,x,x)
References: <BLU122-W7F7E7A4757CD0F4C72C3BDACC0@phx.gbl> <20090124080100.0843df1a@infradead.org> <BLU122-W460604D42E2337F7CA32D4DACC0@phx.gbl>
In-Reply-To: <BLU122-W460604D42E2337F7CA32D4DACC0@phx.gbl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hallberg wrote:
>>> How does one write stuff like
>>> #if LINUX_VERSION_CODE>= KERNEL_VERSION(2,6,28)
>>> if the 4 digit EXTRA_VERSION also is needed?u
>> if you need that something is wrong....
>>
>> can you be more elaborate in what you're trying to achieve ?
> 
> Between 2.6.28 and 2.6.28.1 you changed the function grab_cache_page
> to grab_cache_page_write_begin and added a flags argument. Since I
> maintain an separate filesystem module I need to take care of this.
> From the change log:
...
>     commit 54566b2c1594c2326a645a3551f9d989f7ba3c5e upstream.

There is a simple trick.  Have a look at that commit.  It adds
#define AOP_FLAG_NOFS			0x0004
to <linux/fs.h>.  You could check for it with #ifdef.

Or you could choose to not support 2.6.28, only 2.6.28.y.
-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/
