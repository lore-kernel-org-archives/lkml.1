Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbZAMEqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbZAMEqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 23:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbZAMEqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 23:46:07 -0500
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:36281 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329AbZAMEqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 23:46:06 -0500
Date: Mon, 12 Jan 2009 21:45:44 -0700
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dieter Ries <clip2@gmx.de>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       travis@sgi.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.29-rc1 does not boot
Message-ID: <20090113044544.GA22166@ellpspace.math.ualberta.ca>
References: <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com> <20090112112608.GB19388@elte.hu> <496B3331.1070709@gmx.de> <20090112122145.GA28636@elte.hu> <496B71D5.8030002@gmx.de> <20090112185954.GB15494@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112185954.GB15494@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 07:59:54PM +0100, Ingo Molnar wrote:
> * Dieter Ries <clip2@gmx.de> wrote:
> 
> > 
> > This is what I have got:
> > 
> > [   12.340122] =============================================
> > [   12.341044] [ INFO: possible recursive locking detected ]
> > [   12.341044] 2.6.29-rc1-00041-gacd1e11 #143
> > [   12.341044] ---------------------------------------------
> > [   12.341044] events/0/9 is trying to acquire lock:
> > [   12.341044]  (events){--..}, at: [<ffffffff80254783>]
....
> > Hope that helps,
> 
> thanks, it helps!

I bumped into something pretty similar, although not precisely the
same, with 2.6.29-0.28.rc1.fc11.x86_64 Fedora rawhide kernel.

=============================================
[ INFO: possible recursive locking detected ]
2.6.29-0.28.rc1.fc11.x86_64 #1
---------------------------------------------
events/0/6 is trying to acquire lock:
 (events){--..}, at: [<ffffffff8105b843>] flush_workqueue+0x0/0xa4

but task is already holding lock:
 (events){--..}, at: [<ffffffff8105ae26>] run_workqueue+0xb1/0x20a

It appears that this during an initialization of AC97 sound system.
What I got is at https://bugzilla.redhat.com/show_bug.cgi?id=479778
and close to the bottom of
https://bugzilla.redhat.com/attachment.cgi?id=328808

It is a throw of a dice if this kernel will boot or not.

   Michal
