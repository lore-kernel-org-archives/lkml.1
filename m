Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYHERrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYHERrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761089AbYHERrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:47:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44076 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869AbYHERrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:47:36 -0400
Date: Tue, 5 Aug 2008 18:29:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
 interfaceforon access scanning
Message-ID: <20080805182944.262f20d7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805103840.1aaa64a5@infradead.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	<1217948212.27684.120.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	<1217956796.11547.12.camel@paris.rdu.redhat.com>
	<20080805103840.1aaa64a5@infradead.org>
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

> And this can be done from userland with the preload: the "workaround"
> from the preload assumes you've already executed malicious code, which
> is outside of your protection scope.
> 
> What am I missing?

Scripts
Attempts to screen content
Exec occuring after ld.so is compromised


Is there anything however that cannot be done with SELinux if you added
the ability to block an open and kick it upwards (including the open of
an exec binary)

It seems you would then get a transition from a label of 'trusted' to
'untrusted_unverified' and an open of untrusted_unverified can (depending
on the SELinux rule) then block, trap upwards and continue according to a
userspace response.

At that point all the questions like 'what do I want to scan for' become
SELinux questions and we already have all the technology to do stuff like
'only scan for samba' or 'only scan for httpd and cgi' and do it
efficiently.

The cache then becomes the labels which are already part of the fs and
our existing labelling and context management.

Alan
