Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYEOIoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYEOIoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYEOIoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:44:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62171 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbYEOIoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:44:10 -0400
Message-ID: <482BF744.6060106@cn.fujitsu.com>
Date: Thu, 15 May 2008 16:41:40 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
       fubar@us.ibm.com, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: handle errors from device_rename
References: <20080514170316.672f809d@extreme> <20080514181543.744b8286@extreme>
In-Reply-To: <20080514181543.744b8286@extreme>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger said the following on 2008-5-15 9:15:
>  rollback:
> -	device_rename(&dev->dev, dev->name);
> +	err = device_rename(&dev->dev, dev->name);
> +	if (err) {
> +		memcpy(dev->name, oldname, IFNAMSIZ);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
no need, dev->name didn't change in device_rename().
 
> +		return err;
> +	}
>  
