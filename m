Return-Path: <linux-kernel-owner+w=401wt.eu-S1030343AbXBZRLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030343AbXBZRLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030345AbXBZRLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:11:44 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:62581 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030343AbXBZRLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UeQMkz10ij/4BqEOFqkaVM5dxQ18z4f3FqRGTLuERhZBwmiFpRvMc8pT4pA62sAiSJ7rIEHGPKAoQwC4+LhYIZebD0NbQ4ko+Ot4VjB7EZH/oLQnyZjRHgFZ3PbB1NpFefs735jcPuBCWgY9I/47GiDndM5TVXHFXQZCaN2GKjE=
Subject: Re: [Linux-fbdev-devel] 2.6.21-rc1 dims my LCD
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <1172504617.5824.102.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
	 <1172490091.5824.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
	 <20070226142157.GA2909@khazad-dum.debian.net>
	 <1172501357.5824.91.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261617240.10496@twin.jikos.cz>
	 <1172504617.5824.102.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 01:13:59 +0800
Message-Id: <1172510039.7101.3.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 15:43 +0000, Richard Purdie wrote:
> On Mon, 2007-02-26 at 16:24 +0100, Jiri Kosina wrote:
> > On Mon, 26 Feb 2007, Richard Purdie wrote:
> > 
> > > Jiri: I've appended a patch that should already be queued, could you
> > > test and see if it solves the problem.
> > 
> > Thanks. In the meantime I have gone through the code and I can confirm 
> > that this is the root cause of what I am observing.
> > 
> > Now regarding the patch - at the time when the dim happened previously, 
> > currently there is a observable blink (after which the brightness is 
> > correct). 
> 
> The reason for the behaviour is that its turning the backlight down/off
> to save power as it thinks the screen is blank. The blink therefore
> makes sense as far as the backlight class is concerned and its working
> as intended now.
> 
> > I have put some debugging printk() into fb_notifier_callback(), 
> > and it turns out that on FB_EVENT_CONBLANK, there are two successive calls 
> > to backlight_update_status(), second immediately following the first one:
> > 
> > Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 1, bd->props.brightness == 0
> > Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 0, bd->props.brightness == 0
> > 
> > Is this really a right thing to do?

Well, no, the console should not blank and immediately unblank. Of
course, the console can blank after some time and can be induced to
unblank after a keyboard event, for example.

Besides the debugging printk's, can you also add something like
WARN_ON(1); so you can get a tracing too.

Tony


