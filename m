Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbXCSC1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbXCSC1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 22:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933686AbXCSC1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 22:27:24 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2383 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663AbXCSC1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 22:27:23 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: is RSDL an "unfair" scheduler too?
Date: Sun, 18 Mar 2007 19:27:23 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEMBCFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <45FCD449.60303@argo.co.il>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 18 Mar 2007 19:27:29 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 18 Mar 2007 19:27:31 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I didn't suggest adding any unfairness!  I suggested being fair by
> user/job/process instead of being fair by thread (which is actually
> unfair as it favors multi threaded processes over single threaded
> processes).

Wouldn't that be unfair because it favors multi-user approaches over
single-user approaches with the same number of processes?

Consider two otherwise equivalent web server designs. They both use a helper
process owned by the user who owns the file the web server is sending. One
does a lot of work in the helper process, the other does very little. A
"fair by user" scheduler would give the approach that puts more work in the
helper process more CPU than the one that puts little work in the helper
process.

Being fair by user builds lots of assumptions into the scheduler. When
they're not true, the scheduler becomes sub-optimal. For example, consider a
web server that runs two very important tools, 'foo' and 'bar'. Rather than
running them as root, they run as users 'foo' and 'bar' for security. "Fair
to user" would mean that just because most other people are using 'foo', I
get less CPU when I try to use 'foo', because the OS doesn't know the "real
user", just the fake user who owns the process -- a security decision that
has no relationship to fairness. This would be handled perfectly by a "fair
to process" approach.

As for favoring multi-threaded processes over single-threaded processes,
sometimes that's what you want. Consider two servers, one using thread per
job the other using process per job. Does it make sense to give the "process
per job" server as much CPU to do a single task as the "thread per job"
server gets for all the clients it's dealing with?

It's really more important that the scheduler be tunable and predictable.
That way, we can tell it what we want and get it. But the scheduler cannot
read our minds.

DS


