Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZD2Oeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZD2Oeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZD2Oef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:34:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54729 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZD2Oee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:34:34 -0400
Date: Wed, 29 Apr 2009 15:34:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Martin Knoblauch <knobi@knobisoft.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090429143403.GJ8633@ZenIV.linux.org.uk>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <1241014725.15095.19.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241014725.15095.19.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 04:18:45PM +0200, Mike Galbraith wrote:
> > /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> > have been done to cause that...
> 
> Yeah, but how does one go about doing that?
> 
> Using mount -f, I can convince mount to succeed, but I still have only
> one entry in /proc/mounts, despite what my mount binary imagines.

Huh?
       -f     Causes  everything to be done except for the actual system call;
              if it's not obvious, this ``fakes'' mounting  the  file  system.
              This  option is useful in conjunction with the -v flag to deter-
              mine what the mount command is trying to do. It can also be used
              to add entries for devices that were mounted earlier with the -n

What are you talking about?

The interesting part is why mount(2) doesn't fail with -EBUSY on that
overmounting.  Is there anything else mounted on /sys?  That, or any
interesting patches applied to the tree (fs/sysfs/mount.c, fs/namespace.c)
