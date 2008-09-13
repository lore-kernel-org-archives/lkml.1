Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYIMUHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYIMUHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 16:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYIMUHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 16:07:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35166 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbYIMUHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 16:07:22 -0400
Date: Sat, 13 Sep 2008 14:05:07 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbmon: fix tiny race exposed by the fastboot patches
Message-Id: <20080913140507.91f8b0fe.zaitcev@redhat.com>
In-Reply-To: <20080913124858.529fb8e2@infradead.org>
References: <20080913124858.529fb8e2@infradead.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008 12:48:58 -0700, Arjan van de Ven <arjan@infradead.org> wrote:

> +++ b/drivers/usb/mon/mon_main.c
> @@ -361,12 +361,12 @@ static int __init mon_init(void)
>  	}
>  	// MOD_INC_USE_COUNT(which_module?);
>  
> -	usb_register_notify(&mon_nb);
>  
>  	mutex_lock(&usb_bus_list_lock);
>  	list_for_each_entry (ubus, &usb_bus_list, bus_list) {
>  		mon_bus_init(ubus);
>  	}
> +	usb_register_notify(&mon_nb);
>  	mutex_unlock(&usb_bus_list_lock);

Looks like the above does not add new deadlocks and does not
miss notifications, so ACK.

-- Pete
