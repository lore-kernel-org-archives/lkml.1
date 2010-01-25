Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146Ab0AYXZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0AYXZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537Ab0AYXZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:25:39 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:59562 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab0AYXZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:25:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LscQul7TJfdpUGGsX67G6Gm1wjIAl+qeUKWaFzSUgFoFGwXDP/MhTqltyj52slDEGL
         KLh5S51TmBLjwvB2tma5KgJs5sK4qcUhGGP3trU0KUhFa+8BkXSSHgczaAakF+G6epOn
         FvWnwCmaCTmuP7WHwW6LaoJjtFCzg+9npj9p0=
Date: Mon, 25 Jan 2010 15:25:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: ajax@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: evdev regression on macbook with 2.6.33-rc5
Message-ID: <20100125232520.GC30307@core.coreip.homeip.net>
References: <3d8471ca1001231053k512011dcnfab50052ce3667fa@mail.gmail.com>
 <20100124093055.GA17607@core.coreip.homeip.net>
 <3d8471ca1001251449g6bdbdb4fn11f566b41691f870@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca1001251449g6bdbdb4fn11f566b41691f870@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 11:49:20PM +0100, Guillaume Chazarain wrote:
> On Sun, Jan 24, 2010 at 10:30 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > DOes the same behavior happens when you try using 'evtest' utility while
> > in console?
> 
> Hi Dmitry,
> 
> While struggling to make evtest show keyboard events, I discovered
> that the problem is an incompatibility with mouseemu
> (http://packages.ubuntu.com/karmic/mouseemu) as killing it makes the
> keyboard work fine.
> 
> So, with mouseemu running, evtest won't print any event at all even if
> I move the mouse, and when mouseemu is off everything works fine and
> evtest prints the expected events.
> 

Ah, well, I checked out the sources for this fine specimen. Oh man...
Then we have Debian guys adding their perls to keyboard handler:

++	if (inp.type != EV_KEY && inp.type != EV_REP)
++		return;

Obviously EV_SYN is completely useless message. And who cares about
keyboards with scroll wheels, volume sliders, etc, right?

This package either needs lots of love or it just needs to die...

-- 
Dmitry
