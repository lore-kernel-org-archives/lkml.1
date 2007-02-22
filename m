Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbXBVSpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbXBVSpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXBVSpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:45:45 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:50605 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbXBVSpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:45:44 -0500
Date: Thu, 22 Feb 2007 19:44:47 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: dsaxena@plexity.net, linux-kernel@vger.kernel.org
Subject: Re: Modprobe as script breaks initramfs kernel?
In-Reply-To: <45DD7EED.7030107@tls.msk.ru>
Message-ID: <Pine.LNX.4.61.0702221941290.7553@yvahk01.tjqt.qr>
References: <20070222003309.GA22471@plexity.net> <45DD7EED.7030107@tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 22 2007 14:30, Michael Tokarev wrote:
>Deepak Saxena wrote:
>> We attempted an experiment in cleaning up some modprobe messages during 
>> initramfs bootup when the modules directory is missing by moving modprobe 
>> to modprobe-bin and replacing modprobe with the following simple shell script:
>> 
>> #!/bin/sh
>> # Clean up bootup when modules are not present
>> 
>> if [ -e "/lib/modules/'uname -r'/modules.dep" ] ; then
>> 	/sbin/modprobe-bin $*

The nitpick guide says: `uname -r` and "$@" instead of $*  ;-)

>> else
>> 	exit 0
>> fi
>[]
>> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
>[]
>> Trace; c0107737 <sys_pipe+17/60>
>> Trace; c01030d7 <syscall_call+7/b>
>
>This is the same issue I reported much earlier with /sbin/hotplug being a script
>in initrfamfs.  The problem is because pipefs isn't initialized yet at the time
>the script gets called, and causes a NULL-pointer deref.  Obviously you're using
>pipe above.

Btw, has this pipefs issue been adressed (by moving pipefs before initramfs
stage), or something?


Jan
-- 
