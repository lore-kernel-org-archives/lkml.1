Return-Path: <linux-kernel-owner+w=401wt.eu-S1031060AbXDXL2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031060AbXDXL2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031072AbXDXL2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:28:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031060AbXDXL2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:28:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Date: Tue, 24 Apr 2007 13:32:47 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <200704240110.35770.rjw@sisk.pl> <20070423231926.GA684@tv-sign.ru>
In-Reply-To: <20070423231926.GA684@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704241332.48082.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 April 2007 01:19, Oleg Nesterov wrote:
> On 04/24, Rafael J. Wysocki wrote:
> >
> > On Tuesday, 24 April 2007 00:55, Oleg Nesterov wrote:
> > > On 04/24, Rafael J. Wysocki wrote:
> > > >
> > > > Should I clear it in dup_task_struct() or is there a better place?
> > > 
> > > I personally think we should do this in dup_task_struct(). In fact, I believe
> > > it is better to replace the
> > > 
> > > 	*tsk = *orig;
> > > 
> > > with some helper (like setup_thread_stack() below), and that helper clears
> > > ->freezer_flags. Say, copy_task_struct().
> > 
> > Hmm, wouldn't that be overkill?  copy_task_struct() would have to do
> > *tsk = *orig anyway, and we only need to clear one field apart from this.
> > 
> > Some other fields are cleared towards the end of dup_task_struct(), so perhaps
> > we could clear freezer_flags in there too?
> 
> Yes. And I strongly believe it is bad we don't have the helper which does some
> random stuf like "p->did_exec = 0".
> 
> The same for thread_info. Could you answer quickly where do we clear TIF_FREEZE
> currently? We don't.

Right.

That said, I think the right thing to do would be to add just one line
'freezer_flags = 0' to dup_task_struct() directly in this patch and then
move all of the random stuff (including this line) to the helper in a separate
patch.

I mean, the introduction of the helper seems to be logically unrelated to the
other things this patch does, so it should go in another patch IMHO.

Greetings,
Rafael
