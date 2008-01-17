Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYAQPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYAQPCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYAQPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:02:07 -0500
Received: from vena.lwn.net ([206.168.112.25]:51749 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbYAQPCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:02:06 -0500
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>, drepper@redhat.com,
       Serge Hallyn <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Extending syscalls (was: [PATCH 1/2] Extend sys_clone and sys_unshare system calls API)
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Thu, 17 Jan 2008 03:48:44 GMT."
             <20080117034844.GA27894@ZenIV.linux.org.uk> 
Date: Thu, 17 Jan 2008 08:02:05 -0700
Message-ID: <25712.1200582125@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro sez:

> Nah, just put an XML parser into the kernel to have the form match the
> contents...
> 
> Al "perhaps we should newgroup alt.tasteless.api for all that stuff" Viro

Heh, indeed.  But we do seem to have a recurring problem of people
wanting to extend sys_foo() beyond the confines of its original API.
I've observed a few ways of doing that:

 - create sys_foo2() (or sys_foo64(), or sys_fooat(), or sys_pfoo(),
   or...) and add the new stuff there.

 - Put a version number into the API somewhere - wireless extensions,
   for example.

 - Set a flag saying "I've stashed some additional parameters somewhere
   else."  That's sys_indirect() and the current proposal for extending
   clone().

 - Just do it all with a kernel-based XML parser.  I think we should
   call this approach sys_viro() in honor of its champion.

 - Do it all in sysfs

The first approach has traditionally been the most popular.  If we have
a consensus that this is the way to extend system calls in the future,
it would be nice to set that down somewhere.  We could avoid a lot of
API blind alleys that way.

jon
