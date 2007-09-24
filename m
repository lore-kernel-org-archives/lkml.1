Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbXIXWGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbXIXWGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbXIXWF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:05:58 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:44673 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbXIXWF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:05:57 -0400
Message-ID: <46F834BD.2040704@tiscali.nl>
Date: Tue, 25 Sep 2007 00:05:49 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Jiri Kosina <jkosina@suse.cz>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [42/50] Fix ipv6 source address handling.
References: <20070924161246.983665021@mini.kroah.org> <20070924162227.GQ13510@kroah.com>
In-Reply-To: <20070924162227.GQ13510@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


can't we also decrease the number of brackets here?

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1021,7 +1021,7 @@ int ipv6_dev_get_saddr(struct net_device
 				hiscore.rule++;
 			}
 			if (ipv6_saddr_preferred(score.addr_type) ||
-			   (((ifa_result->flags &
+			   (((ifa->flags &
 			    (IFA_F_DEPRECATED|IFA_F_OPTIMISTIC)) == 0))) {

make this like this
 			if (ipv6_saddr_preferred(score.addr_type) ||
			   (ifa->flags &
 			    (IFA_F_DEPRECATED|IFA_F_OPTIMISTIC)) == 0) {

or even for clarity's sake:
 			if (ipv6_saddr_preferred(score.addr_type) ||
			   (ifa->flags & (IFA_F_DEPRECATED|IFA_F_OPTIMISTIC)) == 0) {
