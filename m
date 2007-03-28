Return-Path: <linux-kernel-owner+w=401wt.eu-S933900AbXC1HrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbXC1HrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 03:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbXC1HrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 03:47:15 -0400
Received: from styx.suse.cz ([82.119.242.94]:33216 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933900AbXC1HrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 03:47:12 -0400
Date: Wed, 28 Mar 2007 09:51:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Yu <liyu@ccoss.com.cn>
Cc: Marcel Holtmann <marcel@holtmann.org>, Li Yu <raise.sail@gmail.com>,
       hongzhiyi@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       yanghong@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <4609CAF2.3040303@ccoss.com.cn>
Message-ID: <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
References: <200703051532096508636@gmail.com>  <45FE6971.6090503@gmail.com>
 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, Li Yu wrote:

> I also sense this. we may need not such a complete layer at all. 
> Although the work of hiddev/rawdev support does not begin, however, as 
> the design, especially, let hiddev/rawdev live in HIDAL, I think this 
> may need a bit of abstract of transport layer.

JFYI the preliminary version of the hidraw interface is now in the 
hid/usbhid git tree, and has also been in a few recent -mm kernels 
already.

> In current development implementation, the match process still can work 
> in traditional Vendor ID/Product ID way, but it do not reject other 
> means. If the author of driver hope to match for specific HID report, 
> just do it. In fact, the HIDAL only know the result of match process, 
> not how to do it.

The crucial thing here is that all reports but the ones that the driver 
registered to will be processed in a standard way by the generic hid bus 
layer, and those reports that the driver registered to will be ignored by 
the layer, and passed for processing to the driver.

> Er, What's mean of your "HUT", HID Usage Table? if so, I think I have
> already explained we can do it.However, we should supply some convenient
> API for this work. or HIT is other mysterious thing? ;)

Yes, HUT is Hid Usage Table. You can obtain them from 
http://www.usb.org/developers/hidpage/#Usage_Tables

Thanks,

-- 
Jiri Kosina
