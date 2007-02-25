Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXBYAqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXBYAqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933606AbXBYAqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:46:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933621AbXBYAql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:46:41 -0500
Date: Sat, 24 Feb 2007 16:44:48 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       <tony.olech@elandigitalsystems.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] USB Elan FTDI: check for workqueue creation v2
Message-Id: <20070224164448.8fe872c7.zaitcev@redhat.com>
In-Reply-To: <20070224074115.GB10139@cvg>
References: <20070224074115.GB10139@cvg>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007 10:41:15 +0300, Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Thanks a lot for comments and Ack the patch please.

Cyrill, I forgot to mention a couple of points, sorry.

>          printk(KERN_INFO "driver %s built at %s on %s\n", ftdi_elan_driver.name,
> -                 __TIME__, __DATE__);
> +	       __TIME__, __DATE__);

Is this really necessary?

>          respond_queue = create_singlethread_workqueue("ftdi-respond-engine");
> +	if (!respond_queue)
> +		goto err3;

This is good, but...

>          result = usb_register(&ftdi_elan_driver);
>          if (result)
>                  printk(KERN_ERR "usb_register failed. Error number %d\n",
> -                        result);
> +		       result);
>          return result;

What does happen if usb_register fails? Since you fixed the
create_singlethread_workqueue, why not this too?

-- Pete
cc: to Tony@ELAN and linux-usb-devel
