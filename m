Return-Path: <linux-kernel-owner+w=401wt.eu-S965529AbXDBRvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbXDBRvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965540AbXDBRvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:51:46 -0400
Received: from lazybastard.de ([212.112.238.170]:50186 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965529AbXDBRvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:51:45 -0400
Date: Mon, 2 Apr 2007 19:48:01 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 09/16] zlib-decompression-status.diff
Message-ID: <20070402174801.GA23326@lazybastard.org>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012007390.12316@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0704012007390.12316@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 April 2007 20:15:42 +0200, Jan Engelhardt wrote:
>  
> +static inline void putstr(const char *s) {
> +    printk("%s", s);
> +    return;
> +}
> +
>  static int __init crd_load(int in_fd, int out_fd)
>  {
>  	int result;
> @@ -418,7 +423,7 @@ static int __init crd_load(int in_fd, in
>  		return -1;
>  	}
>  	makecrc();
> -	result = gunzip();
> +	result = gunzip(putstr);

You are sure this wasn't meant as an April fools joke?  Passing the
address of an inline function certainly has a humorous aspect. ;)

Also, you can remove the "return;" in the void function and possibly
change this bit to match Documentation/CodingStyle.

> +    if(putstr != NULL) putstr("*");

The patch alternately uses puts() and putstr(), which looks rather odd.
Not sure whether that makes sense or not.

Jörn

-- 
My second remark is that our intellectual powers are rather geared to
master static relations and that our powers to visualize processes
evolving in time are relatively poorly developed.
-- Edsger W. Dijkstra
