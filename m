Return-Path: <linux-kernel-owner+w=401wt.eu-S1030580AbXDPMzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030580AbXDPMzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 08:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030565AbXDPMzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 08:55:12 -0400
Received: from stinky.trash.net ([213.144.137.162]:39698 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030521AbXDPMzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 08:55:11 -0400
Message-ID: <4623722C.40009@trash.net>
Date: Mon, 16 Apr 2007 14:55:08 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] Don't attach callback to a going-away netlink socket
References: <46236082.3000101@sw.ru> <46236102.2080706@trash.net> <462364D2.6010700@sw.ru>
In-Reply-To: <462364D2.6010700@sw.ru>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> Patrick McHardy wrote:
> 
>>>There is a race between netlink_dump_start() and netlink_release()
>>>that can lead to the situation when a netlink socket with non-zero
>>>callback is freed.
>>
>>
>>Can you describe the race in more detail please?
>>
> 
> Here it is:
> 
> [...]
> The proposal it to make sock_orphan before detaching the callback
> in netlink_release() and to check for the sock to be SOCK_DEAD in
> netlink_dump_start() before setting a new callback.


Thanks, good catch. Your patch also looks good.

Acked-by: Patrick McHardy <kaber@trash.net>

