Return-Path: <linux-kernel-owner+w=401wt.eu-S941858AbXHJUM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941858AbXHJUM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935286AbXHJUMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:12:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937341AbXHJUMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:12:46 -0400
Message-ID: <46BCC6DF.2040301@redhat.com>
Date: Fri, 10 Aug 2007 17:13:19 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>, ak@suse.de
CC: Glauber de Oliveira Costa <glommer@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, Steven@smtp2.linux-foundation.org,
       akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
       mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
References: <11865467522495-git-send-email-gcosta@redhat.com>	 <11865468394005-git-send-email-gcosta@redhat.com>	 <11865468431616-git-send-email-gcosta@redhat.com>	 <200708081144.04119.ak@suse.de> <46BB5258.8040609@goop.org>	 <20070809190303.214e5457@the-village.bc.nu> <5d6222a80708101108y62ebfa26n9f47bfc52b48f4a8@mail.gmail.com> <46BCB3A5.8090504@goop.org> <46BCB9C5.4050103@redhat.com> <46BCC414.7060504@goop.org>
In-Reply-To: <46BCC414.7060504@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge escreveu:
> Glauber de Oliveira Costa wrote:
>> I think the idea you gave me earlier of using probe_kernel_address could
>> work. Xen/lguest/put_yours_here that won't use an ebda would then have
>> to unmap the page, to make sure a read would fault.
> 
> Hm, the memory might be mapped anyway, but we could make sure its all
> zero.  discover_ebda should be able to deal with that OK.
> 
>     J
Indeed, as the EBDA_ADDR_POINTER is not aligned, this may work even better.

It seems to me safe to assume that if we read zero on that line:

ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);

We could just do ebda_size = 0 and go home happy, skipping the rest of 
the process.

Andi, are you okay with it ?

