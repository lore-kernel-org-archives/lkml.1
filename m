Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbXGOVmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbXGOVmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXGOVmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:42:04 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:47484 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbXGOVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:42:01 -0400
X-Greylist: delayed 2175 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jul 2007 17:42:01 EDT
Subject: Re: [PATCH] ieee1394: forgotten dereference...
From: Ben Collins <ben.collins@ubuntu.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1IAAFz-00053t-Tt@ZenIV.linux.org.uk>
References: <E1IAAFz-00053t-Tt@ZenIV.linux.org.uk>
Content-Type: text/plain
Organization: Canonical
Date: Sun, 15 Jul 2007 22:05:39 +0100
Message-Id: <1184533539.6454.101.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-07-15 at 20:59 +0100, Al Viro wrote:
> Going through the string and waiting for _pointer_ to become '\0'
> is not what the authors meant...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/ieee1394/nodemgr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
> index c4d3d41..51a1206 100644
> --- a/drivers/ieee1394/nodemgr.c
> +++ b/drivers/ieee1394/nodemgr.c
> @@ -283,7 +283,7 @@ static ssize_t fw_show_##class##_##td_kv (struct device *dev, struct device_attr
>  	memcpy(buf,							\
>  	       CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA(class->td_kv),	\
>  	       len);							\
> -	while ((buf + len - 1) == '\0')					\
> +	while (buf[len - 1] == '\0')					\
>  		len--;							\
>  	buf[len++] = '\n';						\
>  	buf[len] = '\0';						\

ACK

Definitely looks right with your patch. Thanks.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

