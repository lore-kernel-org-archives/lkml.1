Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbXKEXOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbXKEXOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXKEXOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:14:12 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1658 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbXKEXOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:14:11 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Policy on dual licensing?
Date: Mon, 5 Nov 2007 15:13:10 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEHLIAAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <slrnfiopoa.9cu.lkml.only@localhost.localdomain>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 05 Nov 2007 15:14:20 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 05 Nov 2007 15:14:22 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> What I suppose is that people porting BSD code to Linux don't mean
> closing the doors for back-porting changes. They are simply unaware
> or forget about the possibility of dual licensing. Obviously, each
> submitter should read Documentation/SubmittingDrivers, where it is
> explicitly stated. Yet humans are prone to forgetting, so this may
> seem not enough.
>
> What I propose is implementing a policy on accepting such code.
> According to it, every time a maintainer is considering a driver
> that is derived from BSD and licensed GPL-only, should request
> for dual licensing before accepting the patch. If the submitter is
> reluctant to do so - what can we do, it's better to have this inside
> this way than not at all. However, this should minimize such cases
> and, hopefully, satisfy the claims about Linux maintainers not doing
> all that they could to make the world a better place.
>
> Best regards,
> Remigiusz Modrzejewski

This will result in more code in the Linux tree that has a license other
than the project default. This will impose a greater and greater burden on
developers who have to carefully check the license of files every time they
cut and paste code from one file into another.

It creates a serious risk of incorrect license notices (because someone
cuts/pastes a substantial chunk of GPL-only code into a dual-licensed file
without changing the license notice) and accidental copyright violations
(because someone else took the cut/pasted part into a BSD-licensed project)
if intimately-connected files are under different licenses. Every effort
should be made to avoid this.

Having a clear policy would be a good idea. I think the general policy
should be that any dual-licensed file should contain a clear notice that the
Linux kernel is GPL (that is the only license 'guaranteed' to cover the
entire distribution) and that development may result in the file being
"contaminated" by code that is not dual-licensed.

Just a notice referring to a 'dual license FAQ' in Documention would be
fine, of course. That file should advise developers that they should remove
the dual license if they cause the file to be no longer dual-licensable due
to code they've added, cut/pasted, or modified. Gratuitous removal of
dual-licensing should be discouraged, but removing it should be encouraged
where it's a genuine impediment to development.

The example I always use is if we have a filesystem with a different
license. Imagine if a new function is added to the filesystem interface. It
is offered in a 'generic' version, with the expectation that filesystems
will override it to provide a better-performing version. Imagine if the
generic version is GPLv2-only and a filesystem in-tree is dual licensed.

A developer probably cannot cut/paste the generic version as a base without
breaking the dual license. If they want to keep the dual license, they have
to re-implement the function. This creates an increased risk of bugs or
incompatibilities. Worse, it creates a maintenance headache in that this
function will need to be understood separately from other filesystems'
implementation of the same function. A little imagination will allow one to
imagine many ways this can cause problems.

The only good way this can end is if they change the license on that file to
GPL only. Possible bad ways include accidentally contaminating the
apparently dual-licensed file with code that was offered by its author only
under the GPL.

DS


