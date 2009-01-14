Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbZANMSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbZANMSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbZANMSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:18:31 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:5363 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbZANMSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:18:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAF5mbUnCTtAn/2dsb2JhbACBbMwihW8
Date: Wed, 14 Jan 2009 13:18:23 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
Message-ID: <20090114121823.GA32180@frolo.macqel>
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel> <200901141259.50237.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901141259.50237.arnd@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:59:49PM +0100, Arnd Bergmann wrote:
> On Wednesday 14 January 2009, Philippe De Muyter wrote:
> > Actually, I was thinking about reducing the footprint of my kernel by
> > removing all the fs-related system calls, so the problem is not where
> > the file-system is, but how to access (serial) devices without giving their
> > "/dev/..." name.
> 
> One thing that you can do is remove support for block devices in somewhat
> recent kernels, which gets you most of the way. File systems themselves
> are required for the majority of all system calls (anything that takes
> a file descriptor) and for the boot process.

file descriptor is actually an historical name, now too particular.

I would like to keep sockets and serial lines, for which the handle is a
"file descriptor", but not use any file.  So, of course I need to keep
write(), read(), poll(), socket() etc, but not open(), link(), mknod() and
everything that walks a directory tree.

Philippe
