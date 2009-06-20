Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbZFTBmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbZFTBmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZFTBmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:42:04 -0400
Received: from web39802.mail.mud.yahoo.com ([209.191.106.63]:47201 "HELO
	web39802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751114AbZFTBmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:42:03 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2009 21:42:03 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type;
  b=kCVago3aT8xKcS6nMEEjz3ZIEOBrH4GYBRTHhp6eK2tslkTpOVECIL7f4wIGBnx7FSa2i7AxoO/uRD8XIBdxoZU20d9O9yS0oWXC0qwbVM/ZGMoh5ewBA9MDOrzftuVN8we4Q3TVnozcgsq+AmV+ZUSLYPSJggz/ppCxFlfHkUc=;
Message-ID: <284842.70159.qm@web39802.mail.mud.yahoo.com>
X-YMail-OSG: rvx8LaIVM1mk_uBYXHWlaXNbMpD2HwUQ.TCIqipUga3uuJw6HnV75PNoDwqBZ21ApDVzfAh0sS3pnzk3Y_lH2j3DDmfWMQ2LHkgyWHRS089P7EMKEv7y.s6_DD078R7sadrpokOvVBgnIRXW9KP47EvMaqLeQ1mK2Mai.BMYjAeOEbm9zfS2OKVFdZypZZO6RO9jXm5YYjjfpUpiIIbWVLmOZYx4VYyGaGIKEda0JK.s5OTjUUUC6lq_GN3svQmg2WVmoUwHnrLPI1gcCciSo6u9Y71_gUsVQkPF0ORnjcx.d3ybKa_1Ng--
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.15
References: <1245096771-3966-1-git-send-email-lrodriguez@atheros.com>  <20090615223206.GA4966@kroah.com> <20090616004122.GC5492@tesla>  <20090616021011.GF23972@bombadil.infradead.org>  <20090616032034.GA17932@kroah.com> <20090616042113.GA5680@tesla>  <20090616093401.GA11602@jm.kir.nu> <20090616181705.GB31506@tesla>  <20090619150015.GC1389@ucw.cz>  <43e72e890906191010v4b2e79a5x2c7b722b8209933c@mail.gmail.com> <dd18b0c30906191041l5aa09b73xc788af6d6ba7c24c@mail.gmail.com>
Date: Fri, 19 Jun 2009 18:35:24 -0700 (PDT)
From: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Subject: netlink interface change and crash while feeing associated sk_buff.
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux net <linux-net@vger.kernel.org>
In-Reply-To: <dd18b0c30906191041l5aa09b73xc788af6d6ba7c24c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hello everybody,

I had a question regarding the new netlink interface in the kernels I guess since 2.6.24 and forward. 
It looks like the entire netlink interface has changed since that kernel version.

Before the change the netlink function prototype used by drivers is :

void netlinkInput(struct sock *sk, int len) 

but this has now changed to :
void netlinkInput(struct sk_buff * skb).

A problem that I am having in my driver is when I receive an skb from my application by the call to sendmsg, I get the packet as an skb in my driver. 

Now once I send out the packet and when its time to free the skb, I call dev_kfree_skb_any(skb).

However, this code seems to crash in the freeing of this skb. Is there something wrong that I am doing in the feeing of this skb. Can it not be freed at this point?

Any thoughts?

Thank you.
Vinay



      
