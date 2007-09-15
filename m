Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbXIORMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbXIORMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 13:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXIORMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 13:12:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbXIORMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 13:12:08 -0400
Message-ID: <46EC1244.7090803@cv-sv.de>
Date: Sat, 15 Sep 2007 19:11:32 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070803 SUSE/1.1.4-3.1 SeaMonkey/1.1.4
MIME-Version: 1.0
CC: Pete Zaitcev <zaitcev@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.23-rc6: usb 1-1: device not accepting address 2, error -62
References: <46EAFCF7.1030907@cv-sv.de>	<20070915034819.3e695370.akpm@linux-foundation.org> <20070915095628.491c8a86.zaitcev@redhat.com>
In-Reply-To: <20070915095628.491c8a86.zaitcev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+Z4liR3C0VJepPWAD1IvSxZ/+HR5x/+i0RctE
 19terj6CNOrNWrzqjYfwDG/w0PLptXzVZIxCOx5BwoMJ0wpHiF
 blZ4iqtK+7EXqR0QhbRUw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Zaitcev wrote:
> On Sat, 15 Sep 2007 03:48:19 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>>> I have an error message with 2.6.23-rc6.
>>> This did not happen with 2.6.22.
>> Another one for Michal's dirt file.
> 
> No, I think it's the module ordering again.
> 
>>> 2.6.23-rc6 boot.msg extract ( hub/usb )
> 
> I wish users stopped this filtering, it's a very bad idea.
> 
Sorry about this. I want to keep the postings shorter.
Please see my earlier reply for the complete messages made
with CONFIG_PRINTK_TIME and CONFIG_USB_DEBUG

> As it is, there's no message showing when ehci_hcd was loaded.
> We can try piece together the picture:
> 
>>> <6>usb usb1: configuration #1 chosen from 1 choice
>>> <6>hub 1-0:1.0: USB hub found
>>> <6>hub 1-0:1.0: 2 ports detected
>>> <6>usb usb2: configuration #1 chosen from 1 choice
>>> <6>hub 2-0:1.0: USB hub found
>>> <6>hub 2-0:1.0: 2 ports detected
>>> <6>usb 1-1: new low speed USB device using ohci_hcd and address 2
> 
> ok this was ohci_hcd
> 
>>> <3>usb 1-1: device not accepting address 2, error -62
>>> <6>usb 5-2: new full speed USB device using uhci_hcd and address 2
> 
> was ehci here? We don't know but I bet it was, because:
> 
>>> <6>usb 6-2: new high speed USB device using ehci_hcd and address 2
> 
>>> 2.6.22 boot.msg extract ( hub/usb )
> 
> This one seems far shorter. The EHCI comes online late here as well,
> but not as late as in the "regression" case. I am wondering if we
> have some kind of "parallel PCI probing" option in action here.

I can send my .config on request.

The system itself is a regular suse 10.2.


> 
> -- Pete
> 

Christian
