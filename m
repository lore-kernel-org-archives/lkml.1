Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbZJLI5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbZJLI5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbZJLI5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:57:49 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:45795 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbZJLI5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JOMG0y1mBmNpXpLv98VCo/lrf3w/peBzQ/JvU1GbQs1T86VQuvmg0psEAxahImJr6y
         ZpjdZyYqg0O9GwSM5K6EmsK5c+Cl957497dkLD6YS4I84sW38/wgwiiHk3FYsj9yjmo8
         4+bsQwDBTcFO1A1ekeXbALOFOugrfBsi9LWbc=
Date: Mon, 12 Oct 2009 01:57:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org
Subject: Re: Regression?: keyboard state/LED inconsistency in
	2.6.32-rc1/2,3,4
Message-ID: <20091012085708.GA7403@core.coreip.homeip.net>
References: <200910121118.29415.mitov@issp.bas.bg> <20091012083015.GA11483@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012083015.GA11483@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:30:15AM +0200, Vojtech Pavlik wrote:
> On Mon, Oct 12, 2009 at 11:18:28AM +0300, Marin Mitov wrote:
> > Hello,
> > 
> > I'm testing 2.6.32-rc1/2,3,4 and I'm using 2.6.31.3.
> > There is a difference in keyboard/LED behavior.
> > If in BIOS NumLock is set on, when the kernel starts
> > it puts NumLock off and the LED state is off in 2.6.31.3
> > (which is consistent), but in 2.6.32-rc1/2,3,4 the LED
> > stays on (and this is not consistent with keyboard's state).
> > 
> > Comparing drivers/input/keyboard/atkbd.c (I'm using it)
> > in 2.6.31.3 and 2.6.32-rc1/2,3,4 among others changes I
> > found the following lines (see the patch bellow) deleted,
> > so I propose either to add them again (this will restore 
> > keyboard/LED consistency) or revert the patch that has 
> > deleted them.
> 
> Oh, wow, those lines are quite clearly needed, I wonder why they got
> deleted, and I'm too lazy to find the commit comment ...
> 

Hmm, it appears I deleted a bit too much.. At some point I was thinking
the input core would reset LEDs and repeat rate on newly created device
but it was wrong idea. Unfortunately I was careless in applying atkbd
patch removing resume support (which should be handled by the input
core)...

-- 
Dmitry
