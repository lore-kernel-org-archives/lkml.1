Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbXLMHlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbXLMHlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbXLMHlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:41:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:56081 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbXLMHlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:41:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=thi+Jth5/qAfmfXfBAFQ6EZj8h85oYrvXuhzFNJmlMrgCTUjGsSvn+u0+pOG70qlxLtOlOirnhd1CLlvcYIW5O9Gjo0/2PYsn6N31sLuKmUfDAvqt8onY9Z1C/GEwTu0oD6uAV78+7hiemtjKQ9lw2dM0Yv6Y5bGsGpDFT4upyI=
Message-ID: <b25c3fa70712122341q3ba282cdqda3fa56901b14484@mail.gmail.com>
Date: Thu, 13 Dec 2007 16:41:19 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [RFC] net: napi fix
Cc: "David Miller" <davem@davemloft.net>, gallatin@myri.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org,
       "Jesse Brandeburg" <jesse.brandeburg@intel.com>
In-Reply-To: <47602B77.2090202@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47601A73.5010804@myri.com>
	 <20071212.093819.205755031.davem@davemloft.net>
	 <47602B77.2090202@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/13, Kok, Auke <auke-jan.h.kok@intel.com>:
> David Miller wrote:
> > From: Andrew Gallatin <gallatin@myri.com>
> > Date: Wed, 12 Dec 2007 12:29:23 -0500
> >
> >> Is the netif_running() check even required?
> >
> > No, it is not.
> >
> > When a device is brought down, one of the first things
> > that happens is that we wait for all pending NAPI polls
> > to complete, then block any new polls from starting.
>
> I think this was previously (pre-2.6.24) not the case, which is why e1000 et al
> has this check as well and that's exactly what is causing most of the
> net_rx_action oopses in the first place. Without the netif_running() check
> previously the drivers were just unusable with NAPI and prone to many races with
> down (i.e. touching some ethtool ioctl which wants to do a reset while routing
> small packets at high numbers). that's why we added the netif_running() check in
> the first place :)
>
> There might be more drivers lurking that need this change...
>
> Auke
>

Also in my case, without netif_running() check, I cannot do ifconfig down.
It stucked if packet generator was sending packets.

Thanks
Joonwoo
