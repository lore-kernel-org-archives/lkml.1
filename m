Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbZATDIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbZATDIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 22:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZATDIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 22:08:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39158 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZATDIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 22:08:35 -0500
Date: Tue, 20 Jan 2009 12:07:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: matthltc@us.ibm.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
Message-Id: <20090120120728.9be81131.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830901191752o53926bdbve593301aeff7330f@mail.gmail.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	<20090109153219.dd8c153d.kamezawa.hiroyu@jp.fujitsu.com>
	<1232072445.7955.40.camel@localhost>
	<6599ad830901191752o53926bdbve593301aeff7330f@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 17:52:36 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Jan 15, 2009 at 6:20 PM, Matthew Helsley <matthltc@us.ibm.com> wrote:
> >
> >        My feeling is this should be a signal subsystem rather than a NOOP
> > subsystem. Then, if users want the grouping for something besides
> > signaling, it doesn't matter if they don't issue any signals via the
> > signal.send file. Also, I think Paul's suggestion would be just as
> > useful for a signal subsystem.
> 
> The signal subsystem is similar to the "no-op" subsystem in that
> neither of them actually need any state - in principle, it could be
> useful to attach a signal subsys to multiple mounted hierarchies, to
> provide signal semantics for each of them.
> 
In my understanding, "sending signal" requires some protocol/order in userland.

Assume that users has to send signal in following order
  Application A -> Application B -> Application C.....
and may have problems sending signals in following order
  Application B -> Application A ->.....

So, signal and noop(just classify apps) is not equivalent in this semantics.

> Would it make sense to allow a class of subsystem that explicitly has
> no state (or at least, has no state that has a global meaning on the
> machine), so that it can be multiply-mounted?
> 
multilply-mounted means its own hierachy can be created per mount point ?
If so, signal subsystem can be used instead of noop.

Thanks,
-Kame

