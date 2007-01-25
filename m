Return-Path: <linux-kernel-owner+w=401wt.eu-S965448AbXAYPVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965448AbXAYPVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965459AbXAYPVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:21:47 -0500
Received: from [217.111.56.2] ([217.111.56.2]:47587 "EHLO semtex.sncag.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965448AbXAYPVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:21:47 -0500
To: torvalds@linux-foundation.org
Cc: bunk@stusta.de, linux-kernel@vger.kernel.org
Subject: unfixed regression in 2.6.20-rc6 (since 2.6.19)
From: Rainer Weikusat <rainer.weikusat@sncag.com>
Date: Thu, 25 Jan 2007 16:20:55 +0100
Message-ID: <877ivb2kvc.fsf@semtex.sncag.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.19 introduced changes to the UHCI handling of interrupt URBs that
caused at least some keyspan USB-to-serial converters to fail, because
the driver code incorrectly assumes that all URBs of the device are
bulk URBs, while some of them (in the default configuration) are
actually interrupt URBs. This has been reported via kernel bugzilla as
bug 7544 on 2006/11/17:

	http://bugzilla.kernel.org/show_bug.cgi?id=7544

I happen to use such a device, but I didn't have the time to deal with
this issue until end of december. A fix for this regression has been
available at least since 2006/12/26. The patch available via bugzilla
has been reworked by me because of comments from Mr. Kroah-Hartmann,

	http://marc.theaimsgroup.com/?l=linux-kernel&m=116783507105717&w=2

It has been part of the -mm tree until about three days ago and was
then dropped by Andrew Morton because Mr Kroah-Hartmann added a
structurally identical and functionally neutral (or slightly worse)
rewritten-by-him version of it to something called 'gregkh-2.6',
presumably, judging from the age of other patches in this particular
tree (back until 2006/09/19), to never see the light of the day again.

If this issue is not going to be fixed for some reason, it would at
least be appropriate to close the bugzilla entry with something like
WILL_NOT_FIX, because that appears to be the situation at present and
for an indefinite time to come.
