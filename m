Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYFBFdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYFBFdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYFBFdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:33:15 -0400
Received: from 1wt.eu ([62.212.114.60]:1413 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbYFBFdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:33:15 -0400
Date: Mon, 2 Jun 2008 07:32:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Joe Peterson <joe@skyrush.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080602053256.GF5609@1wt.eu>
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48438126.3080308@t-online.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 07:12:06AM +0200, Harald Dunkel wrote:
> Hi Joe,
> 
> Joe Peterson wrote:
> >Hi Harold,
> >
> >Doing "ps" while hung shows stty in the "T" state.  "killall -9 stty"
> >releases it.
> >
> 
> Does strace give you the same output if you attach it to the blocking
> stty (strace -p $pid)?
> 
> I got
> 
> 
> :
> ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo ...}) = 
> ? ERESTARTSYS (To be restarted)
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
> :

Guys, you should test if "kill -CONT $pid" wakes the process up.
It might be possible that some obscure bug appeared in the tty
code resulting in SIGTTOU sometimes being sent to the caller,
although that seems rather strange :-/

Willy

