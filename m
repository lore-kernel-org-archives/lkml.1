Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbYHES16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbYHES16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761094AbYHES1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:27:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:48691 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbYHES1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:27:49 -0400
Date: Tue, 5 Aug 2008 11:27:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Eric Paris" <eparis@redhat.com>, "Greg KH" <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
 interfaceforon access scanning
Message-ID: <20080805112747.2c3c4650@infradead.org>
In-Reply-To: <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	<1217948212.27684.120.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	<1217956796.11547.12.camel@paris.rdu.redhat.com>
	<20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 14:04:26 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> 
> However, I want to point out that scanning on close is still an
> integral part of AV protection, even if intercepting opens and execs
> theoretically catches everything.


but close is... very limited in value. Open is a discrete event
traditionally associated withh permission checks.
Close... not so.  (And if you mmap memory, you can then close the file
and still write to it via the mmap)

Lets ask it differently: what will you do if you find something nasty?
You can't fail the close... so why block for it?
And if you don't block for it... all you would need is an asynchronous
notification... something like... inotify
