Return-Path: <linux-kernel-owner+w=401wt.eu-S1422832AbXBVLbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422832AbXBVLbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422851AbXBVLbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:31:03 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20932 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422832AbXBVLbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:31:01 -0500
Message-ID: <45DD7EED.7030107@tls.msk.ru>
Date: Thu, 22 Feb 2007 14:30:53 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Thunderbird 1.5.0.5 (X11/20060813)
MIME-Version: 1.0
To: dsaxena@plexity.net
CC: linux-kernel@vger.kernel.org
Subject: Re: Modprobe as script breaks initramfs kernel?
References: <20070222003309.GA22471@plexity.net>
In-Reply-To: <20070222003309.GA22471@plexity.net>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Deepak Saxena wrote:
> We attempted an experiment in cleaning up some modprobe messages during 
> initramfs bootup when the modules directory is missing by moving modprobe 
> to modprobe-bin and replacing modprobe with the following simple shell script:
> 
> #!/bin/sh
> # Clean up bootup when modules are not present
> 
> if [ -e "/lib/modules/'uname -r'/modules.dep" ] ; then
> 	/sbin/modprobe-bin $*
> else
> 	exit 0
> fi
> 
[]
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
[]
> Trace; c0107737 <sys_pipe+17/60>
> Trace; c01030d7 <syscall_call+7/b>

This is the same issue I reported much earlier with /sbin/hotplug being a script
in initrfamfs.  The problem is because pipefs isn't initialized yet at the time
the script gets called, and causes a NULL-pointer deref.  Obviously you're using
pipe above.

/mjt
