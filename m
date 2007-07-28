Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbXG1Sz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbXG1Sz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 14:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbXG1Szs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 14:55:48 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4326 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbXG1Szo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 14:55:44 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Volanomark slows by 80% under CFS
Date: Sat, 28 Jul 2007 11:55:35 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEEIFLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <b647ffbd0707280536q4a7c5da3he3ec6e2a8a19fc00@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 28 Jul 2007 11:56:17 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 28 Jul 2007 11:56:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Volanomark runs better
> > and is only 40% (instead of 80%) down from old scheduler
> > without CFS.

> 40 or 80 % is still a huge regression.
> Dmitry Adamushko

Can anyone explain precisely what Volanomark is doing? If it's something
dumb like "looping on sched_yield until the 'right' thread runs and finishes
what we're waiting for" then I think any regression can be ignored.

This applies if and only if CFS' sched_yield behavior is sane and Volano's
is insane.

A sane sched_yield implementation must do two things:

1) Reward processes that actually do yield most of their CPU time to another
process.

2) Make an effort to run every ready-to-run process at the same or higher
static priority level before re-scheduling this process. (That won't always
be possible due to SMP issues, but a reasonable effort is needed.)

If CFS is doing these two things, and Volanomark is looping on sched_yield
until the 'right thread' runs, then CFS is doing the right and Volanomark
isn't. Volanomark deserves to lose.

If CFS binds processes to processors more tightly and thus sched_yield can't
yield to a process that was planned to run on another CPU in the future,
that would be a legitimate complaint about CFS.

DS


