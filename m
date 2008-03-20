Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbYCTWqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbYCTWqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYCTWqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:46:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbYCTWqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:46:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Date: Thu, 20 Mar 2008 23:45:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Stern <stern@rowland.harvard.edu>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
References: <Pine.LNX.4.44L0.0803182228520.10154-100000@netrider.rowland.org> <m1ve3jtmxk.fsf@ebiederm.dsl.xmission.com> <20080320104019.GA6870@elf.ucw.cz>
In-Reply-To: <20080320104019.GA6870@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803202345.25083.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 20 of March 2008, Pavel Machek wrote:
> On Tue 2008-03-18 21:25:27, Eric W. Biederman wrote:
> > Alan Stern <stern@rowland.harvard.edu> writes:
> > 
> > > On Wed, 19 Mar 2008, Rafael J. Wysocki wrote:
> > >
> > >> Well, I've been saying that for I-don't-remember-how-long: on my box, if you
> > >> use S5 instead of entering S4, the fan doesn't work correctly after the
> > >> resume.  Plain and simple.
> > >> 
> > >> Perhaps there's a problem with our ACPI drivers that causes this to happen,
> > >> but I have no idea what that can be at the moment.
> > >
> > > IMO it would be worthwhile to track this down.  It's a clear indication 
> > > that something is wrong somewhere.
> > >
> > > Could it be connected with the way the boot kernel hands control over
> > > to the image kernel?  Presumably ACPI isn't prepared to deal with that
> > > sort of thing during a boot from S5.  It would have to be fooled into
> > > thinking the two kernels were one and the same.
> > 
> > It should be easy to test if it is a hand over problem, by turning off
> > the laptop by placing it in S5 (shutdown -h now) and then booting same
> > kernel again.
> 
> Feel free to help with testing.
> 
> I believe ACPI is simply getting confused by us overwriting memory
> with that from old image. I don't see how you can emulate it with
> shutdown.

Well, in fact ACPI has something called the NVS memory, which we're supposed
to restore during the resume and which we're not doing.  The problem may be
related to this.

I have fixing that on my todo list, but frankly there's many different things
in there. :-)

Thanks,
Rafael
