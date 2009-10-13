Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZJME7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZJME7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZJME7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:59:03 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:59142 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbZJME7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:59:02 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Regression?: keyboard state/LED inconsistency in 2.6.32-rc1/2,3,4
Date: Tue, 13 Oct 2009 07:55:43 +0300
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc4; KDE/4.2.4; x86_64; ; )
Cc: Vojtech Pavlik <vojtech@suse.cz>, linux-kernel@vger.kernel.org
References: <200910121118.29415.mitov@issp.bas.bg> <20091012085708.GA7403@core.coreip.homeip.net> <20091013030314.GA2887@core.coreip.homeip.net>
In-Reply-To: <20091013030314.GA2887@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910130755.43510.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009 06:03:14 am Dmitry Torokhov wrote:
> On Mon, Oct 12, 2009 at 01:57:08AM -0700, Dmitry Torokhov wrote:
> > On Mon, Oct 12, 2009 at 10:30:15AM +0200, Vojtech Pavlik wrote:
> > > On Mon, Oct 12, 2009 at 11:18:28AM +0300, Marin Mitov wrote:
> > > > Hello,
> > > > 
> > > > I'm testing 2.6.32-rc1/2,3,4 and I'm using 2.6.31.3.
> > > > There is a difference in keyboard/LED behavior.
> > > > If in BIOS NumLock is set on, when the kernel starts
> > > > it puts NumLock off and the LED state is off in 2.6.31.3
> > > > (which is consistent), but in 2.6.32-rc1/2,3,4 the LED
> > > > stays on (and this is not consistent with keyboard's state).
> > > > 
> > > > Comparing drivers/input/keyboard/atkbd.c (I'm using it)
> > > > in 2.6.31.3 and 2.6.32-rc1/2,3,4 among others changes I
> > > > found the following lines (see the patch bellow) deleted,
> > > > so I propose either to add them again (this will restore 
> > > > keyboard/LED consistency) or revert the patch that has 
> > > > deleted them.
> > > 
> > > Oh, wow, those lines are quite clearly needed, I wonder why they got
> > > deleted, and I'm too lazy to find the commit comment ...
> > > 
> > 
> > Hmm, it appears I deleted a bit too much.. At some point I was thinking
> > the input core would reset LEDs and repeat rate on newly created device
> > but it was wrong idea. Unfortunately I was careless in applying atkbd
> > patch removing resume support (which should be handled by the input
> > core)...
> > 
> 
> Could you please try the patch below and let me know if it fixes
> things?
> 
> Thanks!
> 

Yes, Dmitry, it fixes the problem, thank you.

Marin Mitov
