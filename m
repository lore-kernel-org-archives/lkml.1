Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYJWBdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYJWBdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYJWBdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:33:37 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:35550 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYJWBdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:33:36 -0400
Message-ID: <48FFD46A.9040809@skyrush.com>
Date: Wed, 22 Oct 2008 19:33:30 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix n_tty/pty input/output buffer full and other misc
 char handling
References: <48F2E450.1070508@skyrush.com> <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

I have separated this patch into its separate components, since I know
we are still thinking about how to address the pty "gridlock" issue, and
at least two of the other issues addressed can probably be fixed now.

I will shortly send out 4 new patches that replace the original combined
"tty-fix-buffer-full-handling.patch" patch (these all will apply, in
order, on top of your current tty git tree):

	1) n-tty-fix-cont-and-ctrl-output.patch
	2) n-tty-fix-buffer-full-checks.patch

These two can probably be applied and tested now, since I believe these
are straightforward fixes.  #1 simply fixes what looks like an oversight
in the output block processing WRT continuation chars and ctrl chars.
#2 fixes what appear to be problems that cause loss of characters
because of errors in handling situations when the input buffer is full
or nearly so.

	3) n-tty-output-bells-immediately.patch
	4) n-tty-fix-buffer-full-gridlock.patch

These are the ones that we are still discussing.

Hope this splitting up of the patch helps!

							-Joe
