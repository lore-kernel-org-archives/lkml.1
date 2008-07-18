Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYGRKty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYGRKty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYGRKtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:49:46 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34761 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYGRKtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:49:46 -0400
Message-ID: <48807527.9060806@s5r6.in-berlin.de>
Date: Fri, 18 Jul 2008 12:49:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Subject: Re: PATCH] firewire: add padding to some struct
References: <416371533.19965@ustc.edu.cn>
In-Reply-To: <416371533.19965@ustc.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JiSheng Zhang wrote:
> struct fw_cdev_event_response and struct fw_cdev_event_iso_interrupt need padding.
> Otherwise, offset of the zero length array is not equal to the struct size. It may
> cause some strange problems under some platforms such as sparc32. This
> patch(against 2.6.26) should fix it.

The best solution to this problem would be to use

	offsetof(struct fw_cdev_event_XYZ, data)

instead of sizeof(struct fw_cdev_event_XYZ) in all the places where the
offset is required.

Your proposed solution to add padding...

> --- old/include/linux/firewire-cdev.h	2008-07-18 16:34:01.181794046 +0800
> +++ new/include/linux/firewire-cdev.h	2008-07-18 16:35:46.649294275 +0800
> @@ -92,6 +92,7 @@
>  	__u32 type;
>  	__u32 rcode;
>  	__u32 length;
> +	__u32 pad;
>  	__u32 data[0];
>  };
>  
> @@ -143,6 +144,7 @@
>  	__u32 type;
>  	__u32 cycle;
>  	__u32 header_length;
> +	__u32 pad;
>  	__u32 header[0];
>  };
>  

...can alas not be applied because it would break ABI compatibility.

Thanks for looking into it,
-- 
Stefan Richter
-=====-==--- -=== =--=-
http://arcgraph.de/sr/
