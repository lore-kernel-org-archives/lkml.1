Return-Path: <linux-kernel-owner+w=401wt.eu-S965648AbXC1SoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648AbXC1SoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965638AbXC1SoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:44:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965648AbXC1SoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:44:04 -0400
Date: Wed, 28 Mar 2007 11:41:25 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for driver registration status
Message-Id: <20070328114125.d4f2e650.zaitcev@redhat.com>
In-Reply-To: <20070328160032.GA10233@cvg>
References: <20070325072733.GA10257@cvg>
	<20070326154357.025e4faf@localhost>
	<20070328160032.GA10233@cvg>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 20:00:32 +0400, Cyrill Gorcunov <gorcunov@gmail.com> wrote:

>          result = usb_register(&ftdi_elan_driver);
> -        if (result)
> +        if (result) {
> +		destroy_workqueue(status_queue);
> +		destroy_workqueue(command_queue);
> +		destroy_workqueue(respond_queue);
>                  printk(KERN_ERR "usb_register failed. Error number %d\n",
>  		       result);

I would just change the printk from "couldn't create workqueue"
to something more neutral, but this is ok too. Let's just declare
it fixed and move on.

-- Pete
