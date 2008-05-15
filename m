Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbYEOUJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbYEOUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYEOUJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:09:18 -0400
Received: from mail.vyatta.com ([216.93.170.194]:41713 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbYEOUJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:09:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.747
Date: Thu, 15 May 2008 13:09:11 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
       fubar@us.ibm.com, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: handle errors from device_rename
Message-ID: <20080515130911.6d38c09b@extreme>
In-Reply-To: <482BF744.6060106@cn.fujitsu.com>
References: <20080514170316.672f809d@extreme>
	<20080514181543.744b8286@extreme>
	<482BF744.6060106@cn.fujitsu.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 16:41:40 +0800
Wang Chen <wangchen@cn.fujitsu.com> wrote:

> Stephen Hemminger said the following on 2008-5-15 9:15:
> >  rollback:
> > -	device_rename(&dev->dev, dev->name);
> > +	err = device_rename(&dev->dev, dev->name);
> > +	if (err) {
> > +		memcpy(dev->name, oldname, IFNAMSIZ);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> no need, dev->name didn't change in device_rename().
>  
> > +		return err;
> > +	}
> >  

dev->name has already been changed before the call to device_rename,
so it needs to be set back read the whole code context.
