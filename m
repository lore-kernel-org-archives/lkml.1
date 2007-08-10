Return-Path: <linux-kernel-owner+w=401wt.eu-S941647AbXHJUdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941647AbXHJUdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765905AbXHJUcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:32:55 -0400
Received: from gw.goop.org ([64.81.55.164]:34075 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765166AbXHJUcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:32:54 -0400
Message-ID: <46BCCAFC.5090107@goop.org>
Date: Fri, 10 Aug 2007 13:30:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: ak@suse.de, Glauber de Oliveira Costa <glommer@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, Steven@smtp2.linux-foundation.org,
       akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
References: <11865467522495-git-send-email-gcosta@redhat.com>	 <11865468394005-git-send-email-gcosta@redhat.com>	 <11865468431616-git-send-email-gcosta@redhat.com>	 <200708081144.04119.ak@suse.de> <46BB5258.8040609@goop.org>	 <20070809190303.214e5457@the-village.bc.nu> <5d6222a80708101108y62ebfa26n9f47bfc52b48f4a8@mail.gmail.com> <46BCB3A5.8090504@goop.org> <46BCB9C5.4050103@redhat.com> <46BCC414.7060504@goop.org> <46BCC6DF.2040301@redhat.com>
In-Reply-To: <46BCC6DF.2040301@redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> Indeed, as the EBDA_ADDR_POINTER is not aligned, this may work even
> better.
>
> It seems to me safe to assume that if we read zero on that line:
>
> ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
>
> We could just do ebda_size = 0 and go home happy, skipping the rest of
> the process.

Sure, but it should use probe_kernel_addr as well, just so that it will
be robust against having that page unmapped too.

    J
