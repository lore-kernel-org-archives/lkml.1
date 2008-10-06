Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYJFNkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYJFNkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 09:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYJFNkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 09:40:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:28704 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYJFNkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 09:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DxJLkTDK1lpwoSFbNYtlIfpVGXVanQD6rM58jS8lLuPYS/QP/ynS4BYBj5bJPOYyBd
         Qhf0VASJ4SYtD8vp/98p0zez4+rFrId2i1Qt53Ouc44LDwfzzMbQXtUh+pQe3p484Z9r
         X+jOi4d0LTnkFJYEa4YhKadP+q5ggSz9KvNvg=
Message-ID: <48EA1540.8060409@gmail.com>
Date: Mon, 06 Oct 2008 15:40:16 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
References: <20081005180154.7cc12486@infradead.org> <20081006102739.16d1a434@lxorguk.ukuu.org.uk>
In-Reply-To: <20081006102739.16d1a434@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> This patch adds, to the existing config option to restrict /dev/mem, the
>> reserved regions to the "banned from /dev/mem use" list, so now
>> both kernel memory and device-exclusive MMIO regions are banned.
> 
> This breaks a whole class of diagnostic and debug tools which quite
> intentionally dump the MMIO register space of devices that are live.
> 
> Plus it doesn't actually work - if I have /dev/mem open and mmapped you
> don't pull the pages from under me....
> 
> The problem with the way this is going is the more you take from /dev/mem
> the sooner someone is forced to add /dev/mem-proper which undoes it all
> again so they can get work done.
> 
> It's certainly a useful debug aid to know about such things but I don't
> believe it's something you should ban.

Exactly,

I think the proper solution is to make /dev/mem pure diagnostic tool.
Drivers should use /sys mappings of pci devices to access their iomem
, or even better they should not touch pci mappings
directly at all, but talk to kernel, and if xorg needs access 
to video memory it should talk to drm and get its mapping from there.


Best regards,
	Maxim Levitsky
