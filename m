Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753119AbYLRTYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYLRTYL (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYLRTX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:23:56 -0500
Received: from p02c12o144.mxlogic.net ([208.65.145.77]:35999 "EHLO
	p02c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYLRTXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:23:55 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Dec 2008 14:23:54 EST
Message-ID: <494AA15B.2010000@steeleye.com>
Date: Thu, 18 Dec 2008 14:15:39 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: nbd: clean up error handling
References: <20081218182108.GA13546@elf.ucw.cz>
In-Reply-To: <20081218182108.GA13546@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2008 19:15:40.0447 (UTC) FILETIME=[03FF4AF0:01C96145]
X-Spam: [F=0.2000000000; S=0.200(2008120801)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [71.30.118.242]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

hanks for the patch...

Pavel Machek wrote:
> Uses existing error_out: label instead of hardcoding error action.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

> @@ -475,8 +473,7 @@ static void nbd_handle_req(struct nbd_de
>  	if (nbd_send_req(lo, req) != 0) {
>  		printk(KERN_ERR "%s: Request send failed\n",
>  				lo->disk->disk_name);
> -		req->errors++;
> -		nbd_end_request(req);
> +		goto error_out;

This one is not correct. We don't return immediately here.


--
Paul
