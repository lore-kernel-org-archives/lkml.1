Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbXDCIxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbXDCIxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933364AbXDCIxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:53:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:44566 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933307AbXDCIxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:53:41 -0400
Date: Tue, 3 Apr 2007 10:57:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Yu <raise.sail@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <4611AAC1.8050303@gmail.com>
Message-ID: <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com> 
 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn> 
 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz> 
 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com> 
 <1175516515.5815.347.camel@violet>  <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz>
 <1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Li Yu wrote:

> What's the position of hidraw? It only is used when all other driver is 
> not usable on some report? or, it should be stick every working device.

Current implementation (as you can see it in -mm or in my hid.git tree) is 
creating hidraw interface for just every HID device/interface. But this 
will get changed before merge.

Passing just everything to hidraw is not a good option, as this could lead 
to confusion and duplicating of input events (i.e. in-kernel hid driver 
processes the report and generates input_event(), and also userland driver 
obtains data from hidraw and generates input event through uinput ... not 
good).

> PS: In last broken "flip-flopping" resolution, the USBHID work also need
> some changes ;)

BTW as soon as you have some presentable code, could you please send it so 
that we could see what aproach you have taken? Debating over code is 
usualy more efficient than just ranting random ideas :)

Thanks,

-- 
Jiri Kosina
