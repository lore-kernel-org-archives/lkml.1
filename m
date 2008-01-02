Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYABJ4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYABJ4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYABJ4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:56:43 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20435 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYABJ4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:56:42 -0500
Message-ID: <477B5FD8.5070503@msgid.tls.msk.ru>
Date: Wed, 02 Jan 2008 12:56:40 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: acpi/apm events as inputs: how to handle?
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Not so) recently, ACPI events started appearing as
key press events over linux input subsystem.  The
question regarding this is simple: how it's supposed
to be handled?

First of all, I don't know any software so far that
can handle input layer in userspace when not running
X.  In X, it's usually done using window manager
setup or with special application (like, volume
up/down keys etc).  But without X, there's no such
application, as far as I can see.

It's easy to write one, but there may be.. issues
with finding which input device to use.

Now, linux already have hotplug subsystem, using
/sbin/hotplug helper (or whatever it points to,
or using netlink).  ACPI key events are rare.

What I'm thinking about is: why ACPI events are
routed over input subsystem, instead of hotplug
subsystem?  With input, there's a need for a
special daemon/application listening on the
specific "keyboard" device, while with hotplug
subsystem, it's already here - linux (by default
anyway, if not running udev etc), kernel fires
up a script when an event occurs.  I don't see
how this special application/daemon is different
from ol'good acpid.

Or.. maybe I missed something?

Thanks!

/mjt
