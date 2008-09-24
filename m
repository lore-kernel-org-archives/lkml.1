Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYIXUtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYIXUtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbYIXUsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:48:06 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:37554 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754892AbYIXUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:48:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CUT7AbuYItRHNVjBTFVxjt9M6E3WEGnEpkAt0jg5onzgcHaqzYpiRDeTeWiWDpcGtxfUTBqJYIsaX/DUbW81S1+MUqdcOQjg/DqUiqBgMDgkCj1ugcQL6+1Ts1Ydaz9Sr8C7nXEGxlA9gFilqslVgdkVtBGd+cRsEM0Y9j1KfuI=  ;
X-YMail-OSG: P_eafr0VM1n9jcyN.pbdFa2CaZMrunmu9.BIX_3K8vgCV8gQLJYwAgEMuHwDf9fpAq6msftQD6AViMQ0B_uN17a0pN3iiontVqXeAfN5eHTSGFiVNu3AyY5tVVKcqag7RiSYgjAp_6G.PtRMZpOJmLOzUTUh
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Li Yang-R58472" <LeoLi@freescale.com>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controllerdriver
Date: Wed, 24 Sep 2008 13:26:29 -0700
User-Agent: KMail/1.9.9
Cc: joakim.tjernlund@transmode.se, avorontsov@ru.mvista.com, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
References: <1219916613-28827-1-git-send-email-leoli@freescale.com> <1220342239.7762.14.camel@gentoo-jocke.transmode.se> <0C69E0CDED15E4469A445DE244C1B9F708CEE6@zch01exm26.fsl.freescale.net>
In-Reply-To: <0C69E0CDED15E4469A445DE244C1B9F708CEE6@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809241326.30167.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2008, Li Yang-R58472 wrote:
> 
> > Does RNDIS work too? If not, is it possible to add or doesn't 
> > the HW support it?
> 
> RNDIS is a gadget(protocol) level thing.  I believe it can work with
> this driver although not tested myself.

It should, so long as the QE hardware doesn't try to manage
too many USB protocol details.  Examples would be caring
at all about "config change events" -- SET_CONFIGURATION
picking between one of N configurations, and SET_INTERFACE
picking between altsettings of a given interface.


> Noted:  AFAIK, RNDIS gadget in Linux doesn't interoperate with windows
> well enough to be production level.  Use at your own risk.

Something in the past few releases broke so it may not be
operating much at all, for that matter...

However, it's a fair point that the interoperation requirements
for RNDIS are so badly defined that non-Microsoft code has a
very hard time being robust.

Somewhere in the linux-usb archives is someone's fairly careful
summary of a dozen extremely rude ways the MSFT RNDIS stack
misbehaves.  It'll do things like deciding to stop forwarding
packets to certain applications for a while ... then continuing
after a few minutes as if nothing was wrong.  Blue screens are
a possibility.  Best to wait a few minutes between plugging
and unplugging, while the races between the USB and NET stacks
sort themselves out.

- Dave
