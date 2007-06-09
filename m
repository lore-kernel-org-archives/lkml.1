Return-Path: <linux-kernel-owner+w=401wt.eu-S969546AbXFID0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969546AbXFID0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 23:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbXFID0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 23:26:21 -0400
Received: from bay0-omc3-s8.bay0.hotmail.com ([65.54.246.208]:28256 "EHLO
	bay0-omc3-s8.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877AbXFID0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 23:26:20 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Fri, 8 Jun 2007 23:25:31 -0400
From: Sean <seanlkml@sympatico.ca>
To: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
Cc: david@lang.hm, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and
 manipulation,pathname matching
Message-Id: <20070608232531.d68de09f.seanlkml@sympatico.ca>
In-Reply-To: <200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
References: <200706042303.28785.agruen@suse.de>
	<1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
	<200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 03:26:36.0062 (UTC) FILETIME=[FBFF33E0:01C7AA45]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 11:01:41 +0900
Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp> wrote:


>From the discussion so far, it seems that the different "model" that AA
is trying to implement, is to do in one step what SELinux does in two
steps; that is trying to combine labelling and enforcement into a
single step.  If this is so, then why can't it just feed its automatic
labelling into SELinux enforcement code?

> I tried to give each file it's own label, but I couldn't do it.
> http://sourceforge.jp/projects/tomoyo/document/nsf2003-en.pdf

That paper seems entirely focused on the automatic generation of policy,
and doesn't seem to help the discussion along.   For instance, there may
be a way to implement AA on top of SELinux _without_ giving each and
every file its own label.

> There are many elements that forms too strong barrier between pathname and labels,
> such as bind-mounts, hard links, newly created files, renamed files, temporary files and so on.
> So I gave up giving each file a label that can be used as an identifier,
> and took an approach to forbid unneeded mount operations, unneeded link operations,
> unneeded renaming operations to keep the pathname represent it's own identifier as much as possible.

AA must have a function that decides the security rights for any given
path in order to make its enforcement decisions.  It must surely be able
to deal with all those things you listed above (bind-mounts,hard links etc).
So why can't those decisions be turned into labels that are fed into SELinux
enforcement code?

Sean.
