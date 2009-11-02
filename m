Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbZKBWWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbZKBWWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZKBWWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:22:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:45146 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbZKBWWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:22:52 -0500
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
In-Reply-To: <200911021439.28266.rjw@sisk.pl>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <200911010936.10409.rjw@sisk.pl>
	 <alpine.LFD.2.01.0911010914100.31845@localhost.localdomain>
	 <200911021439.28266.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 09:22:03 +1100
Message-ID: <1257200523.7907.53.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 14:39 +0100, Rafael J. Wysocki wrote:
> 
> > That socket _is_ going to be suspended, and testing for it here just seems 
> > to confuse things. 
> > 
> > So I'd remove it from both early_resume and late_resume, and only keep it 
> > in the case of the legacy user-requested suspend/resume (do we even do 
> > that any more?).
> 
> OK, updated patch is appended.

Test by me delayed to tomorrow ... hit another suspend/resume bug on
that laptop which took away the time I had to do that test yesterday and
today I'm off :-)

(Bug was simple but took a while to track down: machine was left in
storage for a while, battery ran out, RTC went back to Jan 1, 1904,
which means a negative xtime, and the new timekeeping code will do
horrible things including hanging at resume when that happens. Fix is to
make powerpc read_persistent_clock() to ignore the RTC when it contains
a date older than epoch).

Cheers,
Ben.


