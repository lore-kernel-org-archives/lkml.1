Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYDUKnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYDUKnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYDUKnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:43:20 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48585 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbYDUKnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:43:19 -0400
Date: Mon, 21 Apr 2008 14:43:01 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Midhun A <midhunagni@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Userspace - Kernel Space "Connector" test
Message-ID: <20080421104301.GA2061@2ka.mipt.ru>
References: <e1d5030b0803260311j25831caeyd9fc111a06e572e2@mail.gmail.com> <20080327143823.GA20443@2ka.mipt.ru> <e1d5030b0804040001t2a2b2fd3j75c656ec2318a932@mail.gmail.com> <e1d5030b0804210329j38d3bb8cge62e833088c1e0c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1d5030b0804210329j38d3bb8cge62e833088c1e0c@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Apr 21, 2008 at 03:59:32PM +0530, Midhun A (midhunagni@gmail.com) wrote:
> static void imxmci_check_status(unsigned long data)
> {
> 	struct imxmci_host *host = (struct imxmci_host *)data;
> 
> 	/*Netlink*/
> 	struct cn_msg *m;
> 	char cn_data[32] = "SD/MMC Card Status";
> 	/*Netlink*/
> 
> 	if( host->pdata->card_present() != host->present ) {
> 		host->present ^= 1;
> 		dev_info(mmc_dev(host->mmc), "card %s\n",
> 		      host->present ? "inserted" : "removed");
> 
> 	/*Netlink*/
> 
> 	m = kmalloc(sizeof(*m) + sizeof(cn_data), GFP_ATOMIC);
> 
> 	if (m) {
> 		printk("Inside if\n");
> 		memset(m, 0, sizeof(*m) + sizeof(cn_data));
> 		memcpy(&m->id, &cn_test_id, sizeof(m->id));
> 		m->seq = cn_test_timer_counter;
> 		m->len = sizeof(cn_data);
> 
> 		m->len =
> 		    scnprintf(cn_data, sizeof(cn_data), "counter = %u",
> 			      cn_test_timer_counter) + 1;
> 
> 		memcpy(m + 1, data, m->len);
> 		printk("Copied Message\n");		
> 		cn_netlink_send(m, 0, gfp_any());
> 		printk("Sent Message\n");		
> 		kfree(m);

What is return value here?
Also, do you register this driver as connector user? If not, you can not
use 0 group number, since it will search only for registered kernel
side, and if there was no registration, it can not obtain address of the
userspace side. You can specify group (7 in your cae) as a parameter
instead.

I suppose userspace was bound to (1<<7) group number or was subscribed
using socket option to 7'th group.

-- 
	Evgeniy Polyakov
