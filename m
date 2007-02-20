Return-Path: <linux-kernel-owner+w=401wt.eu-S932793AbXBTBaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbXBTBaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932802AbXBTBaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:30:07 -0500
Received: from web36715.mail.mud.yahoo.com ([209.191.85.49]:43704 "HELO
	web36715.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932793AbXBTBaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:30:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zkXAIrVqNQGOYTQBQvj+/Uzl+K7QAtjN6RxCnmlXhQRR1+6V2+pVwcByLwAiAL0hnME3d4EEc9Dij7xnrm4sB6NlAVWmoSuQmyjfi2lgr4qpnZTKBJOwJz9jTzARTyrYJK0vUPyCqDO/9973xU7Kd799Z4l+C9o9yEbs40uWETU=;
X-YMail-OSG: 3Fja18IVM1n4cpp4N86pd4HCbcq6lMwOGTWgZdkHjmTOUgGzKphzIT1GjZrlhXQ2JE3Hm.XpXhFYVW0KA_r6_e3Cn7hkDOfs6HFByC85L4PS3VoVxmJgNeR9XBqNUg_GpzNOesyjCh.tclA-
Date: Mon, 19 Feb 2007 17:30:05 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D9995F.9070108@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <320344.9830.qm@web36715.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > mmc_rescan
> >   mmc_register_card
> >     device_add
> >       mmc_block_probe
> >         mmc_block_alloc
> >           -> queue thread starts running
> >         add_disk
> >           -> issues a lot of requests; card fails, my drivers calls mmc_remove_host, which in 

correction: my driver schedules (wakes kthread in 0.7) mmc_remove_host - noticed it only now

> >              turn calls device_del, though we are still in device_add
> > 
> 

That's why I think that simply flushing the workqueue is enough. If workqueue is empty we know for
sure that device_add has exited.



 
____________________________________________________________________________________
Expecting? Get great news right away with email Auto-Check. 
Try the Yahoo! Mail Beta.
http://advision.webevents.yahoo.com/mailbeta/newmail_tools.html 
