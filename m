Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbXAZVWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbXAZVWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXAZVWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:22:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:9846 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXAZVWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=r6y6KlwwDzdqV25Y+KlCtOy9J/smnJFBJy076waXIavz54MSNZCyhZZdg/pIT2g070GbmKZDi2mCq+MylePBU/OBDI30mjUW5gwgbosKIQK8UEuSycIl/dfOlt0QeOgfBqeXjgBy4PjZN1hKEeLXxfvNdtqYC6p8ZMTgOO1P2EQ=
Date: Fri, 26 Jan 2007 21:22:03 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Jose Goncalves <jose.goncalves@inov.pt>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops on serial access on kernel 2.6.16.38
Message-ID: <20070126212203.GB2990@slug>
References: <45BA2341.40008@inov.pt> <20061226201003.GA2990@slug> <45BA459F.7060604@inov.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA459F.7060604@inov.pt>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 06:17:03PM +0000, Jose Goncalves wrote:
> Frederik Deweerdt wrote:
> > On Fri, Jan 26, 2007 at 03:50:25PM +0000, Jose Goncalves wrote:
> >   
> >> I'm having a problem with the latest 2.6.16 kernel (I've found the
> >> problem on 2.6.16.37 and 2.6.16.38). I have a application that retreives
> >> data from a GPS connected on a serial port. From time to time a get a
> >> kernel Oops, like this:
> >>
> >>     
> > Could you send your .config?
> >   
> Here it goes...
> 
Thanks. It looks like something is wrong with port->ops->startup() in
uart_startup(), could you apply the following patch and report the
results? And btw, you're using a plain 8250 serial port, isn't it?

Regards,
Frederik


diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index cc1faa3..08772dc 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -171,6 +171,10 @@ static int uart_startup(struct uart_state *state, int init_hw)
 		uart_circ_clear(&info->xmit);
 	}
 
+	printk("type is %d\n", port->type);
+	printk("ops is %p\n", port->ops);
+	printk("ops->startup is %p\n", port->ops->startup);
+
 	retval = port->ops->startup(port);
 	if (retval == 0) {
 		if (init_hw) {
