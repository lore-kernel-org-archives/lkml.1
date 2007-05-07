Return-Path: <linux-kernel-owner+w=401wt.eu-S965805AbXEGQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805AbXEGQku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934399AbXEGQkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:40:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39556 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934386AbXEGQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:40:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <463F5677.4080906@s5r6.in-berlin.de>
Date: Mon, 07 May 2007 18:40:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Petr Vandrovec <petr@vandrovec.name>
CC: dan@dennedy.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
References: <20070507021447.GA22197@vana.vc.cvut.cz>
In-Reply-To: <20070507021447.GA22197@vana.vc.cvut.cz>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Vandrovec wrote:
[...]
> * read() always failed with -EFAULT.  This was happening due to
>   raw1394_compat_read copying data to wrong location - access_ok always
>   failed as 'r' is kernel address, not user.  Whole function just tried to
>   copy data from 'r' to 'r', which is not good.
> 
> * write(fd, buf, 52) from 32bit app was returning 56.  Most of callers did not
>   care, but some (arm registration) did, and anyway it looks bad if request for
>   writing 52 bytes returns 56.  And returning sizeof anything in 'int' is not
>   good as well.  So all functions now return '0' instead of
>   sizeof(struct raw1394_request) on success, and write() itself provides correct
>   return value (it just returns value it was asked to write on success as raw1394
>   does not do any partial writes at all).
> 
> * Related to this was problem that write() could have returned 0 when kernel
>   state would become corrupted and moved to different state than
>   opened/initialized/connected.  Now it returns -EBADFD which seemed appropriate.
> 
> * And add compat_ioctl.  Although all structures are more or less same,
>   raw1394_iso_packets got pointer inside, and raw1394_cycle_timer got unwanted
>   padding in the middle.  I did not add any translation for ioctls passing array
>   of integers around as integers seem to have same size (32 bits) on all 
>   architectures supported by Linux.
[...]

Thanks for these fixes.  They look good at first glance but I will look
at them in more detail during the week (and hope that Dan can have a
look at them too).  I will get back to you once more before I commit
because I would like to split it into three patches (for
raw1394_compat_read, for write, and for compat_ioctl).
-- 
Stefan Richter
-=====-=-=== -=-= --===
http://arcgraph.de/sr/
