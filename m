Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZC0LZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZC0LZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZC0LZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:25:23 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:34747 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZC0LZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:25:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Aypej4BhuEbyONNOhP/CpEqoHGKpc/1XmmAqgrAOxMYBfE8vp1H8ZQt5pm5e7Xv/Gw
         LWC1/hVt51PjdWDFIxmLN8oQJsv/gypp2BvNNWWKngZ8RUnLYrg5LPxq7Gq8VMMi7nkx
         C0bxgmhKOs9kcjwmxwf8XxSI/RwpZ+js9oYzs=
Subject: Re: relatime: update once per day patches (was: ext3 IO latency 
 measurements)
From: David Hagood <david.hagood@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       tytso@mit.edu, jack@suse.cz, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
       jens.axboe@oracle.com, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, oleg@redhat.com, roland@redhat.com
In-Reply-To: <20090326122003.5f6f608c.akpm@linux-foundation.org>
References: <20090325123744.GK23439@duck.suse.cz>
	 <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
	 <20090326092454.b74e3f96.akpm@linux-foundation.org>
	 <200903261812.09153.elendil@planet.nl>
	 <20090326104843.46abfaa7.akpm@linux-foundation.org>
	 <20090326184900.GA8580@srcf.ucam.org>
	 <20090326122003.5f6f608c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 06:25:15 -0500
Message-Id: <1238153115.32119.15.camel@surfer>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to me that, rather than having the kernel maintain a timer (or
multiple timers, one per mount) itself, it would make sense to have
entries in /sys which, when written to, cause the file system layer to
flush all atime data to the mounted volume.

Something like
/sys
/sys/atime
/sys/atime/all
/sys/atime/<mountpoint id>/flush

where <mountpoint id> would be the name of the file system
(e.g. /sys/atime/usr/flush).

The only sticky part would be how to describe "/" in such a system.

(Better still would be a /sys/ system for each file system with the
various parameters (e.g. uid, journal) as entries + an entry for
flushing atime, but that is beyond the scope of this discussion.)

That would truly let userspace set policy, while the kernel provides
mechanism. Thus, a script that depends upon atime being accurate could
simply tickle the sysfs entries as needed before running.


