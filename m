Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbZJPFAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbZJPFAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 01:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZJPFAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 01:00:08 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:43570 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbZJPFAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 01:00:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IzZauqM6VPYNi9hAQuJP2gRx/dLe4oBImR3fwmjobVwxq5ZK7SpRacnfXlAat5fS8p
         MYliqqeY67LBpJqNgpWGXoLG8N3qnqFCLvNJQN+/Es17xkEEv6TuaGFeFKVnLAgWQS5Z
         baRlzSwmsCLqNR7pmdIj/xxDKPcQTmCW9eYdw=
Date: Thu, 15 Oct 2009 21:59:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Kosina <jkosina@suse.cz>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20091016045924.GD11582@core.coreip.homeip.net>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de> <20090713040528.GH10819@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907130906140.10476@wotan.suse.de> <20090713082527.GA26638@basil.fritz.box> <alpine.LNX.2.00.0907161057120.11648@wotan.suse.de> <20090716092406.GC8046@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716092406.GC8046@one.firstfloor.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 11:24:06AM +0200, Andi Kleen wrote:
> > Andi, are you absolutely sure that this appeared between .29 and .30 for 
> > you?
> 
> I only noticed it after the .30 update at least.
> 
> > And if so, is there any chance you could try bisecting it?
> 
> Ok.
> 
> > 
> > (*) have been on virtual desktop where firefox was running, switched to 
> > console using Ctrl-Alt-F1, and switched back to X using F7. Firefox then 
> > popped up some dialog about configuring some feature that is triggered by 
> > pressing F7/AltF7, or whatever. Is that what you are seeing?
> 
> Yes, I typically see it with the help screen. It also happens with
> other applications, not just firefox.
> 

I don't really see the issue here, except for maybe X being stupid - it
seems that it processes release events as press+release in cases when it
did not see the press event.

Start up xev, switch to text console and then back to X (don't release
the CTRL+ALT+Fx combo). Let X switch fully and then release the combo.
Observe the 2 events reported by xev for Fx key. You may try running
evtest in other window and observe that there are no down events at the
time of 2 xev events, only autorepeats and release event (and
autorepeats are ignored by X who does it's own software autorepeat).

-- 
Dmitry
