Return-Path: <linux-kernel-owner+w=401wt.eu-S941147AbXHJSxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941147AbXHJSxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932961AbXHJSxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:53:21 -0400
Received: from gw.goop.org ([64.81.55.164]:36496 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757883AbXHJSxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:53:20 -0400
Message-ID: <46BCB3A5.8090504@goop.org>
Date: Fri, 10 Aug 2007 11:51:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, Steven@smtp2.linux-foundation.org,
       akpm@linux-foundation.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       virtualization@lists.linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
References: <11865467522495-git-send-email-gcosta@redhat.com>	 <11865468394005-git-send-email-gcosta@redhat.com>	 <11865468431616-git-send-email-gcosta@redhat.com>	 <200708081144.04119.ak@suse.de> <46BB5258.8040609@goop.org>	 <20070809190303.214e5457@the-village.bc.nu> <5d6222a80708101108y62ebfa26n9f47bfc52b48f4a8@mail.gmail.com>
In-Reply-To: <5d6222a80708101108y62ebfa26n9f47bfc52b48f4a8@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> On 8/9/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>   
>>> What's the EBDA actually used for?  The only place which seems to use
>>> ebda_addr is in the e820 code to avoid that area as RAM.
>>>       
>> It belongs to the firmware.
>>     
>
> Wouldn't it be better, then, to just skip this step unconditionally if
> we are running a paravirtualized guest? What do we from doing it?
>   

It's better to make discover_ebda() quietly cope with a missing ebda for
whatever reason.  We could add an explicit interface to paravirt_ops to
handle this one little corner, but it isn't very important, not very
general and really its just clutter.  Its much better to have things
cope with being virtualized quietly on their own rather than hit them
all with the pv_ops hammer.   pv_ops is really for things where the
hypervisor-specific code really has to get actively involved.

For Xen-domU and lguest, there probably won't be an ebda, but its quite
likely that it will be present in some form for vmware, kvm and
xen-dom0; in those cases the (presumably virtual) ebda will be put in
place as it would be in the native case, eliminating the need for any
special handling.

    J
