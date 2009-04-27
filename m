Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZD0J7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZD0J7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbZD0J4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:56:20 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:21678 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757513AbZD0J4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:56:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iQgP8qxtXA4Sdb2oX60QteDmighBdYgOQvWw0uI12v9MloW1WFqZ6NkGD7ynjmej11qi9ezFJIvAyEXfJqb37x7nhcsK9HMlAKNxqnEP9SB6nBpH8/7KADV6jx2AIxFI6kRRdlYA606YTLrLDiqv8CPRf2YgD2uh2TkR7PBSk9k=  ;
X-YMail-OSG: hrcFoPMVM1ntGa84uXmOIDC8oo5E34kDgoyV5KIzssFifjmq0LF0Q3PzkTKGAJHGABKKVlkC8W7EU.UUrpzyJ82VzqadYvbg53uckBvcTp7OtAGTYGMhEWtFQG0fm00TXvfc.IMmzd4HoqNP0qVQswbjNoJB7NXfnJuvj.aGFP3_2SRGAaqY_JwIsjarhxm8D2VRbtYJ4jESNjERmmfW0bEmSL24MWuyQv0B6GHtz2XDM3AATwHa_F0B4WEuHhdpmXdCuMzPTSCMneXRQqt3HGoLTbXLI143PO2SwDDy9YkTc9bgUs0A
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Grazvydas Ignotas <notasas@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Card detect IRQ errors
Date: Mon, 27 Apr 2009 02:56:15 -0700
User-Agent: KMail/1.9.10
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <6ed0b2680904270213s6ef02ad6i26173245019bca15@mail.gmail.com>
In-Reply-To: <6ed0b2680904270213s6ef02ad6i26173245019bca15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904270256.15871.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Grazvydas Ignotas wrote:
> 
> With current l-o head when I insert or remove SD card I'm getting this:
> 
> [   20.733489] ------------[ cut here ]------------
> [   20.738159] WARNING: at kernel/irq/handle.c:366 handle_IRQ_event+0x4c/0x14c()
> [   20.745330] BUG: IRQ handler called from non-hardirq
> context!Modules linked in:
> ...
> [   20.822753] ---[ end trace 2ca2d8ba630dd6b5 ]---
> [   20.869415] mmc0: card 8001 removed
> 
> Has anyone else seen this?

Regresssion caused by 044d408409cc4e1bc75c886e27ca85c270db104c.

Notice the message is internally broken, too -- no newline.

Try reverting that, things will still behave just fine.

