Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbYI0LWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbYI0LWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 07:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYI0LVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 07:21:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49168 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179AbYI0LVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 07:21:54 -0400
Date: Sat, 27 Sep 2008 12:20:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, arjan@infradead.org, bunk@kernel.org,
       tytso@mit.edu, tvrtko.ursulin@sophos.com, hch@infradead.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, peterz@infradead.org,
       Jonathan.Press@ca.com, riel@redhat.com
Subject: Re: [RFC] 0/11 fanotify: fscking all notifiction and file access
 system (intended for antivirus scanning and file indexers)
Message-ID: <20080927122031.2d4dd1b0@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0809262259290.4229@asgard.lang.hm>
References: <1222463220.2872.193.camel@localhost.localdomain>
	<alpine.DEB.1.10.0809262259290.4229@asgard.lang.hm>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sending a message out for every READ/WRITE seems like it will generate a 
> LOT of messages, and very few will be ones that anyone cares about.

On read there isn't much point anyway, on write if you simply send one,
save an event counter number and don't send another until the last one is
cleared it all works well. When the last event is cleared if another
event has occurred then the event counter will have changed so you know
to send one immediately, if the app doesn't want to receive them for a
while it can just hang onto the event for a minute or two before clearing
it.

