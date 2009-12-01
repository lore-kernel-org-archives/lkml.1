Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZLALb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZLALb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZLALb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:31:57 -0500
Received: from perceval.irobotique.be ([92.243.18.41]:54732 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZLALb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:31:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] usbvideo: limit the length of string creation
Date: Tue, 1 Dec 2009 12:33:12 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.31.1; KDE/4.3.3; x86_64; ; )
Cc: V4L Mailing List <linux-media@vger.kernel.org>, cocci@diku.dk,
       LKML <linux-kernel@vger.kernel.org>
References: <4B081D40.9030607@freemail.hu>
In-Reply-To: <4B081D40.9030607@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912011233.12290.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 November 2009 18:02:56 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Use strlcat() to append a string to the previously created first part.
> The strlcat() function limits the size of the string to the whole
> destination buffer.
> 
> The semantic match that finds this kind of problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression dev;
> expression phys;
> expression str;
> expression size;
> @@
>  	usb_make_path(dev, phys, size);
> -	strncat(phys, str, size);
> +	strlcat(phys, str, size);
> // </smpl>
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
