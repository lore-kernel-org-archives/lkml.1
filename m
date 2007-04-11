Return-Path: <linux-kernel-owner+w=401wt.eu-S1161399AbXDKXAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161399AbXDKXAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161348AbXDKWzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:55:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55670 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161366AbXDKWyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:53 -0400
Date: Wed, 11 Apr 2007 15:52:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       John Heffner <jheffner@psc.edu>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/31] Fix TCP receiver side SWS handling.
Message-ID: <20070411225215.GR24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-tcp-receiver-side-sws-handling.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: John Heffner <jheffner@psc.edu>

[TCP]: Do receiver-side SWS avoidance for rcvbuf < MSS.

Signed-off-by: John Heffner <jheffner@psc.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_output.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1607,6 +1607,9 @@ u32 __tcp_select_window(struct sock *sk)
 		 */
 		if (window <= free_space - mss || window > free_space)
 			window = (free_space/mss)*mss;
+		else if (mss == full_space &&
+		         free_space > window + full_space/2)
+			window = free_space;
 	}
 
 	return window;

-- 
