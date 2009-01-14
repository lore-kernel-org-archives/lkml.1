Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbZANKSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbZANKSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZANKSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:18:33 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:51156 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbZANKSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:18:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADFKbUnCTtAn/2dsb2JhbACBbMt2hW8
Date: Wed, 14 Jan 2009 11:18:28 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
Message-ID: <20090114101828.GA15141@frolo.macqel>
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel> <1231926744.11907.12.camel@skunk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231926744.11907.12.camel@skunk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:52:24AM +0100, Xavier Bestel wrote:
> 
> On Wed, 2009-01-14 at 10:34 +0100, Philippe De Muyter wrote:
> > On Wed, Jan 14, 2009 at 09:46:48AM +0100, Tomasz Chmielewski wrote:
> > >> I need to design a very small embedded system that must only control
> > >> one ethernet port and two serial lines and must fit in a very small flash
> > >> memory.  So I thought about replacing the call to /etc/init by my 
> > >> application
> > >> program and removing all the file-system part of linux.
> > >> Is that doable ?
> > >> Is there a 'standard' way of doing that ?
> > >> The first problem I see is accessing my serial lines.  How could I do that
> > >> without using open("/dev/ttySx"), which requires a file system ?
> > >> Is there a way to access devices that does not require a file-system ?
> > >
> > > You could put everything in initramfs (and embed it in the kernel).
> > 
> > Actually, I was thinking about reducing the footprint of my kernel by
> > removing all the fs-related system calls, so the problem is not where
> > the file-system is, but how to access (serial) devices without giving their
> > "/dev/..." name.
> 
> You can still mount sysfs somewhere and access the device nodes from
> there.

Keeping thinking about it, I now think that my 'application program'
(basically a serial-to-ethernet converter) should be a kernel thread,
because of the small memory constraints.

The question is thus how to access the serial lines from a kernel thread.

Philippe
