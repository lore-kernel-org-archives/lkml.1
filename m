Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbXBRXsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbXBRXsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbXBRXsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:48:24 -0500
Received: from web36711.mail.mud.yahoo.com ([209.191.85.45]:33761 "HELO
	web36711.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752513AbXBRXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:48:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=fEb76b7gjnkS67oQN6690hT01XN/tdjJ6hRpp4nET7bBufrRL6qeUa4pIABNqY4Lx2PnoOckWJhtm9yNXIwrKTcrZkGthRTdYzv+FUdX1tlXjga+UtiuFB0DBs1jQZLJrsX17iYm8wcZjRcGRlq5mbVoGUtdK/PBHoQwbHkk5/8=;
X-YMail-OSG: tuCjfRwVM1miSeI3PNFrDg9B67QHuqMxhBB4FMF5T1itmaa0ZYkKAN6ngNCKRSkZtrKTDE8_5knRKQSyZi3JC9uoknkPJv4o.rU_nYfpF.XFZRdpAeZ6MQPOmFZ8y1XsRESLuah6fMn9X_c-
Date: Sun, 18 Feb 2007 15:48:22 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D86C7B.5050900@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <64677.73649.qm@web36711.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is hard to trigger problem, so I'll spare you the rather lengthy log.
> > It happens if card timeouts and mmc_remove_host is called while mmc_register_card is still in
> > progress (the hint was in crash dump). If I sleep before remove, it gives the
> mmc_register_card
> > chance to finish/mark card as dead and everything's fine.
> > The remove callback of mmc_block is apparently not executed in this case (probably because
> device
> > has not finished registering).
> 
> Let's see, you manage to call mmc_remove_host() when a detection is pending in
> the workqueue? That could indeed generate new request (up until mmc_free_host()
> is called), but as the card is removed the mmc layer shouldn't be able to detect
> anything, hence mmc_block should never get involved.
> 

You'll agree, I think, that add_disk in mmc_block_probe issues a lot of requests (reads partition
table, fs superblocks and such - plenty of room for critical errors). Then, driver's remove method
will not be called before driver's probe method had finished. So mmc_block is quite involved, even
though it does not affect the problem's resolution.

Besides this, I have a new version of the tifm driver to submit. It fixes quite a few problems and
improves performance a little. Hopefully, it's better tested than the previous one.





 
____________________________________________________________________________________
Finding fabulous fares is fun.  
Let Yahoo! FareChase search your favorite travel sites to find flight and hotel bargains.
http://farechase.yahoo.com/promo-generic-14795097
