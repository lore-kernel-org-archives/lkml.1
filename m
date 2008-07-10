Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYGJAj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYGJAj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYGJAjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:39:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52321 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbYGJAjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:39:20 -0400
Date: Thu, 10 Jul 2008 09:42:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/4] Container Freezer: Reuse Suspend Freezer
Message-Id: <20080710094231.58d9e1b9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1215640723.7149.35.camel@localhost.localdomain>
References: <20080707225823.502032693@us.ibm.com>
	<20080708123150.3034d83f.kamezawa.hiroyu@jp.fujitsu.com>
	<1215545954.9023.120.camel@localhost.localdomain>
	<6599ad830807081306l61622eadk215a25d02ee94b00@mail.gmail.com>
	<6599ad830807081307j811689aldf0f6cb38579c450@mail.gmail.com>
	<1215640723.7149.35.camel@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 14:58:43 -0700
Matt Helsley <matthltc@us.ibm.com> wrote:

> 
> On Tue, 2008-07-08 at 13:07 -0700, Paul Menage wrote:
> > On Tue, Jul 8, 2008 at 1:06 PM, Paul Menage <menage@google.com> wrote:
> > > On Tue, Jul 8, 2008 at 12:39 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> > >>
> > >> One is to try and disallow users from moving frozen tasks. That doesn't
> > >> seem like a good approach since it would require a new cgroups interface
> > >> "can_detach()".
> > >
> > > Detaching from the old cgroup happens at the same time as attaching to
> > > the new cgroup, so can_attach() would work here.
> 
> Update: I've made a patch implementing this. However it might be better
> to just modify attach() to thaw the moving task rather than disallow
> moving the frozen task. Serge, Cedric, Kame-san, do you have any
> thoughts on which is more useful and/or intuitive?
> 

Thank you for explanation in previous mail.

Hmm, just thawing seems atractive but it will confuse people (I think).

I think some kind of process-group is freezed by this freezer and "moving
freezed task" is wrong(unexpected) operation in general.  And there will
be no demand to do that from users.
I think just taking "moving freezed task" as error-operation and returning
-EBUSY is better.

Thanks,
-Kame

> > And the whole can_attach()/attach() protocol needs reworking anyway,
> > see my email (hopefully) later today.
> > 
> > Paul
> 
> Interesting. I look forward to seeing this.
> 
> Cheers,
> 	-Matt
> 
> 

