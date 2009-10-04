Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbZJDTCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbZJDTCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbZJDTCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:02:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57522 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbZJDTCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:02:12 -0400
Date: Sun, 4 Oct 2009 21:01:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Deepak Saxena <dsaxena@laptop.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: console resume broken since
	ba15ab0e8de0d4439a91342ad52d55ca9e313f3d
Message-ID: <20091004190125.GF1378@ucw.cz>
References: <20090930151103.GU27039@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930151103.GU27039@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-30 17:11:03, Sascha Hauer wrote:
> 
> This patch fixes setting the console speed if console suspend is disabled
> by breaking it if it is enabled, see below:
> 
> > commit ba15ab0e8de0d4439a91342ad52d55ca9e313f3d
> > Author: Deepak Saxena <dsaxena@laptop.org>
> > Date:   Sat Sep 19 13:13:33 2009 -0700
...
> > 
> >     Set proper console speed on resume if console suspend is disabled
> >     
> >     Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC
> >     XO laptop. Basically what happens is that upon returning from resume,
> >     serial8250_resume_port() will reconfigure the port for high speed
> >     mode and all console output will be garbled, making debug of the
> >     resume path painful. This patch modifies uart_resume_port() to
> >     reset the port to the state it was in before we suspended.
> >     
> >     Original patch by Marcelo Tosatti
> > -		struct ktermios termios;
> > -
> > -		/*
> > -		 * First try to use the console cflag setting.
> > -		 */
> > -		memset(&termios, 0, sizeof(struct ktermios));
> > -		termios.c_cflag = uport->cons->cflag;
> > -
> > -		/*
> > -		 * If that's unset, use the tty termios setting.
> > -		 */
> > -		if (port->tty && termios.c_cflag == 0)
> > -			termios = *port->tty->termios;
> > -
> >  		uart_change_pm(state, 0);
> >  		uport->ops->set_termios(uport, &termios, NULL);
> 
> 
> We call ->set_termios with an unitialized struct ktermios here.
> 
> Any ideas what to do?

Revert the patch for now and make Deepak fix it properly?

Or maybe it is enough to just 'do nothing' in the 'if that's unset'
branch?


								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
