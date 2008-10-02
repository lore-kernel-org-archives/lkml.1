Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYJBJML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYJBJML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYJBJL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:11:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:11459 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYJBJLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LxC6t1GK7N7I4kGg3knlgTgF4TNcGcHVCNW3Vu3Qn2SE26c4mZTydV8MMufXQql6fZ
         eCfY0+Ky9zFW1B2hjETpUyG3yvKYK8cohTM+E/qHYNFBOA9ZQ6jErSrnfmO1jGZatRr+
         3FhmTSxBE7ZcSRnjrpQ4yJhSAqcJoMO0t6v34=
Message-ID: <68676e00810020211w14cff133h8aa9b60fed007122@mail.gmail.com>
Date: Thu, 2 Oct 2008 11:11:55 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: SDHCI: timeout during data transfer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081002101754.031d6710@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923212459.GA13888@dreamland.darkstar.lan>
	 <20081002101754.031d6710@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 10:17 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Tue, 23 Sep 2008 23:24:59 +0200
> Luca Tettamanti <kronos.it@gmail.com> wrote:
>
>> Hi,
>> I'm seeing timeout errors when transfering "big" (over 1MB or so) files to a SD
>> card (small files are ok):
>>
>> [  251.956666] mmcblk0: error -110 transferring data
>> [  251.979810] end_request: I/O error, dev mmcblk0, sector 1572758
>
> Looks like the card died on you there. Did you build the kernel
> yourself? If so, it would be helpful if you could enable
> CONFIG_MMC_DEBUG and give me a complete dmesg dump from when this
> happens.

Will do.

>> kernel in use is 2.6.27-rc6, and this is the controller:
>>
>> 09:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
>> 09:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
>> 09:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
>> 09:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)
>>
>> Googling around I found a patch[1] that introduced a quirk to address an
>> off-by-one issue for the timeout value in certain controllers.
>>
>> With this patch:
>
> The patch doubles the timeout, so something is clearly broken if that
> solves the issue. I'd like to identify if it's the driver, controller
> or card first though.

I was just shooting in the dark ;-) I found the patch floating around
and applied it.

> Are you experiencing this with just this card, or with all?

Actually I have only that card... I'll try to borrow another one for
testing. Btw, that card works fine under windows (on the same machine)
and my N800 is happy with it too.

Luca
