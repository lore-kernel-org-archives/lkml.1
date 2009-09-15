Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZIOL26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZIOL26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZIOL2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:28:52 -0400
Received: from plane.gmane.org ([80.91.229.3]:38161 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbZIOL2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XAc+tBZy1h2y1SYgvS5AxfLxtLXG1w5jqNCoW8DJAyVMoB9Sm2t5SCaB1nXBHf+Ct4
         jTF3UjRvDXpzGUD7RsHBslFbWES6amL2qZ1GJoJPclz7BxDbFS9RflBNFimQf03F0gEJ
         BFhWRPPqOnw99U1Ax4NfsZ294oUE3duSil2s4=
MIME-Version: 1.0
In-Reply-To: <4AAECEF4.9070200@gmail.com>
References: <1252905504-26666-1-git-send-email-vapier@gentoo.org> 
	<4AAECEF4.9070200@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Sep 2009 07:28:23 -0400
Message-ID: <8bd0f97a0909150428t54ac791ahffa24f8b7c61214b@mail.gmail.com>
Subject: Re: [PATCH] Revert "[Bluetooth] Eliminate checks for impossible 
	conditions in IRQ handler"
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Marcel Holtmann 
	<public-marcel-kz+m5ild9QBg9hUCZPvPmw@plane.gmane.org>,
       public-linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
       Michael Hennerich 
	<public-michael.hennerich-OyLXuOCK7orQT0dZR+AlfA@plane.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, Sep 14, 2009 at 19:17, Robert Hancock wrote:
> On 09/13/2009 11:18 PM, Mike Frysinger wrote:
>> Commit ac019360fe3 changed the irq handler logic to BUG_ON rather than
>> returning IRQ_NONE when the incoming argument is invalid.  While this
>> works in most cases, it doesn't work when the IRQ is shared with other
>> devices (or when DEBUG_SHIRQ is enabled).
>
> Something doesn't add up here. It shouldn't be possible for the incoming
> argument to be invalid. I'd think that if it is it means that the IRQ
> handler is being registered too soon, before the data structures it requires
> are set up fully. If that's the case, reverting the change just partially
> papers over the bug.

it's a shared irq.  so there is no way to guarantee that the incoming
interrupt is from the bluetooth device.

aaaand there's the issue of registering too soon, but the pcmcia
framework doesnt seem to provide a way to fix this.  enable
DEBUG_SHIRQ and you too will see the kernel crash (since this causes
the IRQ to "fire" as soon as it's generated).

i dont know anything about these devices, but another fix may be to
remove the shareable flag from the irq registration.
-mike

