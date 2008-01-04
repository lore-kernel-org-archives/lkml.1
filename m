Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYADBCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYADBCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYADBCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:02:07 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:34357 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYADBCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:02:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=F1bdZhhHXzN2SATlTtv3nT42MWeRfZkF6v+DL5Y77Vsui/n4SdPofIwbRA6JhwanJWmztXMV8ZR8z+OVW466nmBdPj1VWaFg3xgAPla6fObfEl8TXRWnh8E+rH9tzg1VybLhCUSAtO4MD8h075atNEDf4DDAFqtD9AXOsrdy4Hg=
Date: Fri, 4 Jan 2008 09:05:42 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080104010542.GA2860@darkstar.te-china.tietoenator.com>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080103131620.GA16307@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103131620.GA16307@boogie.lpds.sztaki.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 02:16:21PM +0100, Gabor Gombas wrote:
> On Wed, Jan 02, 2008 at 04:16:42PM +0100, Gabor Gombas wrote:
> 
> > So the patch referenced above does not help. But I've found a very easy
> > way to trigger the bug:
> > 
> > - do a "cat /dev/zero > /dev/rfcomm0"
> > - switch the phone off
> > - switch the phone on, and the kernel oopses
> 
> FYI I also remember having oopses with 2.6.22.<something> but I do not
> have those logs anymore. Also I now booted 2.6.20.7 and it did not oops.

Could you try the patch (on 2.6.24-rc6) following and check the debug messages? 

diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
--- linux/net/bluetooth/rfcomm/tty.c	2008-01-04 08:58:48.000000000 +0800
+++ linux.new/net/bluetooth/rfcomm/tty.c	2008-01-04 09:01:01.000000000 +0800
@@ -313,6 +313,7 @@ static void rfcomm_dev_del(struct rfcomm
 {
 	BT_DBG("dev %p", dev);
 
+	dump_stack();
 	set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
 	rfcomm_dev_put(dev);
 }
