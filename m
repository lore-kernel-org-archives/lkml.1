Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZFCSXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZFCSXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZFCSXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:23:32 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:35050 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZFCSXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:23:31 -0400
Message-ID: <4A26BF49.6040907@unsolicited.net>
Date: Wed, 03 Jun 2009 19:22:01 +0100
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: John Stoffel <john@stoffel.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, thomas@winischhofer.net
Subject: Re: Patch to fix usbmon crash on Opteron
References: <20090602210932.b74fff08.zaitcev@redhat.com>
In-Reply-To: <20090602210932.b74fff08.zaitcev@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Zaitcev wrote:
> Here's my proposal: forget the clever-by-half tricks and simply use
> transfer_buffer. This should not only fix Opteron, but also future IOMMUs
> that Intel and AMD promise. It may also make usbmon useable on PPC at last.
>
> I think downsides are negligible. The ones I see are:
>  - A driver may pass an address of one buffer down as transfer_buffer,
>    and entirely different entity mapped for DMA, resulting in misleading
>    output of usbmon.
>  - Out of tree drivers may crash usbmon if they store garbage in
>    transfer_buffer. I went over the tree with a comb and fixed obvious
>    bugs, and clarified the documentation in comments.
>  - Drivers that use get_user_pages will not be possible to monitor
>  - Similar deal is with usb_storage transferring from highmem, but
>    it works fine on 64-bit systems, so I think it's not a concern.
>
> I'm adding a sign-off line in case, but in general this is a patch
> for testing. In particular, sisusb is a concern.
>
> David & John, I am quite certain that your Opterons will not crash now,
> but please give it a try, and also you can use this code to produce usbmon
> traces you needed for debugging of other things.
>
> Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
>
>   
Works fine on my system!

Cheers
David
