Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbYBGXij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbYBGXij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYBGXia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:38:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40595 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYBGXi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:38:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Fri, 8 Feb 2008 00:36:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <20080205190600.GB11613@elf.ucw.cz> <200802080006.54151.rjw@sisk.pl> <20080207233509.GB21468@elf.ucw.cz>
In-Reply-To: <20080207233509.GB21468@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802080036.43746.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 8 of February 2008, Pavel Machek wrote:
> Hi!

Hi,

> > > > -	memcpy((void *)acpi_wakeup_address, &wakeup_start,
> > > > -	       &wakeup_end - &wakeup_start);
> > > > -	acpi_copy_wakeup_routine(acpi_wakeup_address);
> > > > +	memcpy((void *)acpi_realmode, &wakeup_code_start, 4*PAGE_SIZE);
> > > 
> > > Using a PAGE_SIZE multiplier here isn't a good thing...
> > 
> > Yes, I'll fix that in one of the next iterations.
> 
> Agreed.
> 
> > > > +	header = (struct wakeup_header *)(acpi_realmode + 0x3f00);
> > > 
> > > ... especially not with magic constants like this.
> > 
> > Yeah.  Pavel, what's at 0x3f00, btw?
> 
> struct wakeup_header.
> 
> I really need the entry point to be at offset 0, so that I can get
> pointers to my data. I could not figure out how to do it any other
> way. And if 0 is taken, I thought I'd put header at the end.

What does the number 0x3f00 follow from?

Rafael
