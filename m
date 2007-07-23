Return-Path: <linux-kernel-owner+w=401wt.eu-S1764007AbXGWQih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764007AbXGWQih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932883AbXGWQiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:38:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:14827 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855AbXGWQiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cCeB+14p0m9zXfPANSrHETZIIVzFncDNdOUuBuufBqFJInDMhqqsv9sNvR5vWQ6FGHuayBkXs7wmu/1U5LuroWN/pnhBvOir4IIgxiY6U6LTASk7TDNK/djdgp0VE4O3JxmWDIAVnopSG1pCdZGGpCL5ZwWZ/aANpkTyyJqTO7o=
Message-ID: <a4e6962a0707230937vc5b23bg93e8b5b7f700aa3e@mail.gmail.com>
Date: Mon, 23 Jul 2007 11:37:41 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: Plan 9 Resource Sharing Support - what is it?
Cc: "kernel list" <linux-kernel@vger.kernel.org>, rminnich@lanl.gov,
       lucho@ionkov.net, v9fs-developer@lists.sourceforge.net
In-Reply-To: <20070723075434.GA9162@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070723075434.GA9162@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> What is "plan 9 resource sharing"? Some kind of mosix-like process
> migration? Could you explain it in two lines in Kconfig?
>
> http://v9fs.sf.net
>
> is redirect to
>
> http://v9fs.sourceforge.net/
>
> which tells me
>
> Moved to SWiK
>
> after clicking on that, I get to page with content, but no
> explanation (could Kconfig/MAINTAINERS be updated?).
>

Sure, I'll try to put something in that is considerably less vague and
I'll update the URLs as well.  We've been somewhat lagging on
documentation.  The most complete explanation is available in the
Freenix paper:
   http://www.usenix.org/events/usenix05/tech/freenix/hensbergen.html

The short answer is that it is a Linux client for sharing file
systems, devices, and system services mapped as synthetic file systems
via a simple protocol.  Its primary focus has been to keep things
simple, and to try and maintain support for being able to effectively
share synthetic file systems (like /proc, or /sysfs, or ones exported
by Plan 9 applications (Russ Cox's Plan 9 ports package contains a set
of Plan 9 applications ported to UNIX such as the Venti content
addressable storage system)).

Its being used internally by (at the very least) IBM Research and Los
Alamos National Labs.  To date we've been focused on the client and a
few specialized servers, we are currently broadening our approach to a
better general-purpose server and evaluating if it makes sense to make
an in-kernel server available.  We've also been looking at using 9p in
the context of virtualized environments to provide file service, and
perhaps sharing of other system resources as well.  Once we have a
better handle on the server story, we'll produce a much larger body of
documentation discussing usage as well as development of 9p file
servers.

There are also side-efforts underway evaluating different methods of
extended the 9p protocol to better support the Linux (and other UNIX)
environments -- ideally without adding a signifigant amount of
complexity.

         -eric
