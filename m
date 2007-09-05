Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbXIERLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbXIERLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbXIERKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:10:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64722 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbXIERKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:10:08 -0400
Date: Wed, 5 Sep 2007 10:09:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: modinfo <modulename> question
Message-Id: <20070905100916.f8e31bff.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0709051232440.22864@p34.internal.lan>
References: <Pine.LNX.4.64.0709051232440.22864@p34.internal.lan>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007 12:34:13 -0400 (EDT) Justin Piszcz wrote:

> Is there anyway to get/see what parameters were passed to a kernel module? 
> Running modinfo -p <module> will show the defaults, but for example, st, 
> the scsi tape driver, is there a way to see what it is currently using? I 
> know in dmesg it shows this when you load it initially (but if say dmesg 
> has been cleared or the buffer was filled up)?

If a "module" (whether built as a loadable module or builtin to the
kernel image) uses module_param() with a permission (or mode) field
that allows reading that parameter, then the parameter will show up
in /sys/module/<module>/parameters/<parameter>.

E.g., drivers/scsi/sg has these parameters listed and are readable
by anyone:

-rw-r--r-- 1 root root 4096 Sep  5 10:07 allow_dio
-rw-r--r-- 1 root root 4096 Sep  5 10:07 def_reserved_size
-rw-r--r-- 1 root root 4096 Sep  5 10:07 scatter_elem_sz

However, the st driver uses 0 for permission (mode), so none of its
parameters is visible.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
