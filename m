Return-Path: <linux-kernel-owner+w=401wt.eu-S966241AbXDDBYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966241AbXDDBYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966240AbXDDBYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:24:50 -0400
Received: from adsl-216-102-214-42.dsl.snfc21.pacbell.net ([216.102.214.42]:51423
	"EHLO cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966239AbXDDBYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:24:49 -0400
Date: Tue, 3 Apr 2007 16:09:08 -0700
From: Brad Boyer <flar@allandria.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070403230908.GA13471@cynthia.pants.nu>
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <1175642916.10567.24.camel@shinybook.infradead.org> <20070403212928.GA12951@cynthia.pants.nu> <1175644642.10567.31.camel@shinybook.infradead.org> <20070403221002.GA13210@cynthia.pants.nu> <1175648051.10567.61.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175648051.10567.61.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 08:54:10PM -0400, David Woodhouse wrote:
> But why? There's nothing special and magical about the number 64 and the
> letters 't' 't' 'y' and 'S'. And if you have broken software which only
> works with ttyS[0123] then you can still create device nodes or symlinks
> to work around that.

I never claimed there was anything magical about those particular values
and I don't intend to do that in the future. The issue is one of
standardization. As an example, Solaris does use the same device names
for both Zilog 8530 and 8250 ports in spite of naming ethernet devices
based on the hardware type. I just checked the man pages on a Solaris 9
system to be sure. The issue is that the naming should be consistent. I
shouldn't need to know what the hardware is to use what is fundamentally
an abstraction of "serial port" as far as the user is concerned. On
Solaris, I can say "/dev/term/a" and know that I will get the first
serial port if it is available without needing to care if it is the
zs, se or asy driver talking to the hardware.

Note that I'm not suggesting we should do what Solaris does because
Sun decided it was the way to do it. I'm just pointing out an example.

> If you're on a platform where 8250 serial ports _cannot_ exist, then
> abusing the 8250 driver's numbers would perhaps be workable, if a little
> strange -- but 8250 ports are ubiquitous. You can attach them to just
> about anything, of any architecture, that Linux runs on. Except perhaps
> S390.

The availability of the specific chip in question is a red herring in
my opinion. I do understand that 8250 compatible chips are very common
and are the most likely serial chips to be used with Linux. However, I
will point out that the define is TTY_MAJOR, not 8250_MAJOR. It seems
to me that whoever named it was thinking in more generic terms.

> Yes, it would be theoretically possible to come up with a way to share
> minor numbers so we can use 'ttyS0' for the first serial port regardless
> of what type of port it is. We could take the arch-specific hack that
> SPARC has and try to move it to generic code. But what's the point?

The point is that people are used to having "ttyS0" mean the first
onboard serial port. I firmly believe that the user-space programs
should need to know as little as possible about the hardware, and it
would be nice to abstract that away from the end user as well. We've
moved toward commonality and standarization in other areas, and I
think we should here as well.

	Brad Boyer
	flar@allandria.com

