Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbXDCPt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbXDCPt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbXDCPt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:49:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbXDCPtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:49:55 -0400
Date: Tue, 3 Apr 2007 08:48:03 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Kok, Auke" <sofar@foo-projects.org>
Cc: Nicolas Mailhot <nicolas.mailhot@laposte.net>, video4linux-list@redhat.com,
       Michael Bueker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, zaitcev@redhat.com
Subject: Re: OHCI: USB webcam works, but not on USB Hub
Message-Id: <20070403084803.e578260d.zaitcev@redhat.com>
In-Reply-To: <46127134.7000108@foo-projects.org>
References: <53190.192.54.193.51.1175611316.squirrel@rousalka.dyndns.org>
	<46127134.7000108@foo-projects.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 08:22:28 -0700, "Kok, Auke" <sofar@foo-projects.org> wrote:

> Having the gspca driver move into the main tree would help a lot though.

I think we need to articulate better why this is an issue and not just
an excuse. We know that scheduling issues with ISO transfers exist, but
with the driver outside we can't find a specific issue let alone fix it.
These things are hard to fix as it is.

For example, an external 2.0 hub with TT moves all transactions from OHCI
to EHCI, and adds an interrupt transfer which eats into your schedule.
I'm completely unsurprised that this fails. Wanna bet that Michael's
issue is something like that?

Another thing, requiring them to make the effort comes with an implicit
promise to fix whatever the user's problem is once they have moved gspca
in-tree. I'm not ready to tackle Michael's case, so I pretended not to
see his original mail.

-- Pete
