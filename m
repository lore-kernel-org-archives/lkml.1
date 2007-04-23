Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbXDWUDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbXDWUDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXDWUDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:03:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34433 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXDWUCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:02:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Date: Mon, 23 Apr 2007 21:57:19 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <200704222139.27128.rjw@sisk.pl> <20070423131720.GE25144@in.ibm.com>
In-Reply-To: <20070423131720.GE25144@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232157.20232.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 April 2007 15:17, Gautham R Shenoy wrote:
> On Sun, Apr 22, 2007 at 09:39:26PM +0200, Rafael J. Wysocki wrote:
> > @@ -63,9 +100,9 @@ static inline int thaw_process(struct ta
> >   */
> >  static inline void frozen_process(struct task_struct *p)
> >  {
> > -	p->flags |= PF_FROZEN;
> > +	set_frozen_flag(p);
> >  	wmb();
> > -	clear_tsk_thread_flag(p, TIF_FREEZE);
> > +	do_not_freeze(p);
> 
> We may want to rename do_not_freeze to something else. It kind of
> looks weird calling do_not_freeze(p) after setting the frozen flag!
> 
> Probably, just a matter of taste :-)

Hmm, I wanted to avoid changing the existing names in this patch, but in this
particular case you are obviously right.  I'll change that to
clear_freeze_flag().

Greetings,
Rafael
