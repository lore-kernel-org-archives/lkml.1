Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbYGWOFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbYGWOFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYGWOEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:04:53 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:59738 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbYGWOEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:04:53 -0400
Date: Wed, 23 Jul 2008 18:04:50 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jerome Arbez-Gindre <jeromearbezgindre@gmail.com>
Cc: linux-kernel@vger.kernel.org, deweerdt@free.fr
Subject: Re: New IDX in linux/connector.h ?
Message-ID: <20080723140450.GA30991@2ka.mipt.ru>
References: <a1d7a2f20807230540l4aa7e3f5i1511a2ea71fed8a9@mail.gmail.com> <20080723125307.GA12017@2ka.mipt.ru> <a1d7a2f20807230645t461265ecu2d9e7f70484a8c91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d7a2f20807230645t461265ecu2d9e7f70484a8c91@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 03:45:09PM +0200, Jerome Arbez-Gindre (jeromearbezgindre@gmail.com) wrote:
>  diff --git a/include/linux/connector.h b/include/linux/connector.h
> index 96a89d3..361996c 100644
> --- a/include/linux/connector.h
> +++ b/include/linux/connector.h
> @@ -38,6 +38,7 @@
>  #define CN_W1_VAL			0x1
>  #define CN_IDX_V86D			0x4
>  #define CN_VAL_V86D_UVESAFB		0x1
> +#define CN_IDX_BB			0x5
> 
>  #define CN_NETLINK_USERS		5

Update this number too.
While it is less than 32, it does not matter, but just for the record.

> > I even wanted to have private indexes, i.e. those which are supposed to
> > be used by out-of-the-tree code, and no in-kernel users would ever touch
> > this numbers.
> 
> So which numbers am I suppose to use ... taking account that BB will
> probably stay for a long time out-of-the-tree ?

You can use whatever VAL number you like:

struct cb_id cn_dst_id[] = {{CN_DST_IDX, 1}, {CN_DST_IDX, 2}, {CN_DST_IDX, 3}};

for (i=0; i<ARRAY_SIZE(cn_dst_id); ++i)
  cn_add_callback(&cn_dst_id[i], "DST", cn_dst_callback_func);

So cn_dst_callback_func() will be invoked for
idx=CN_DST_IDX,val={1,2,3}, you can determine val parameter from the
provided header and make appropriate decition.
You can also register multiple different callbacks for each idx.val
pair of course.

-- 
	Evgeniy Polyakov
