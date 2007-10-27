Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbXJ0TWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbXJ0TWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbXJ0TWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:22:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:18986 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbXJ0TWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZVNGriKqV4sAp7vNuoUDWuMpQi6pPSN1UlFcX119UlzHy10Q9y6NKqQPgvu3X0oulIsMJnuslICuFBTEcWgJN+LM/OVsSn48KZ0qr26njax9XJgwbFpVIXmk7wctDkoh4bIcYeDfC5OvEv0qxRFWFyjsMvC+jF7FdY5cHx22OcI=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] QUESTION: How to fix race between .suspend routine and watchdog timer
Date: Sat, 27 Oct 2007 21:19:44 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0710271516570.30287-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0710271516570.30287-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710272119.44574.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2007 21:17:55 Alan Stern wrote:
> On Fri, 26 Oct 2007, Maxim Levitsky wrote:
> 
> > > > Looking through the dmfe code, I noticed yet another possible race.
> > > > A race between the .suspend, and a timer that serves both as a watchdog, and link state detector.
> > > > Again I need to prevent it from running during the suspend/resume, but how?
> > > > 
> > > > I can use del_timer in .suspend, and mod_timer in .resume, but that doesn't protect against
> > > > race with already running timer.
> > > > I can use del_timer_sync, but it states that it is useless if timer re-enables itself, and I agree with that.
> > > > In dmfe case the timer does re-enable itself.
> > > 
> > > That comment isn't right.  del_timer_sync works perfectly well even if
> > > the timer routine re-enables itself, provided it stops doing so after a
> > > small number of iterations.
> > Thanks for the info. but....
> > Due to the "don't access the hardware, while powered-off" rule, I must know that the timer isn't running.
> > and won't be.
> > So what function to use (if possible) to be sure that the timer won't run anymore?
> > (Taking in the account the fact that it re-enables itself)
> 
> Use del_timer_sync().  It guarantees that when it returns, the timer 
> will be stopped and the timer routine will no longer be running on any 
> CPU.
> 
Even if the timer re-enables itself, are you sure?

> Alan Stern
> 
> 

Best regards,
	Maxim Levitsky
