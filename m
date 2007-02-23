Return-Path: <linux-kernel-owner+w=401wt.eu-S1750838AbXBWDoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838AbXBWDoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXBWDoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:44:17 -0500
Received: from [63.240.77.82] ([63.240.77.82]:33026 "EHLO
	sccrmhc12.comcast.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbXBWDoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:44:15 -0500
X-Greylist: delayed 97607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Feb 2007 22:44:15 EST
Date: Thu, 22 Feb 2007 19:44:58 -0800
From: Deepak Saxena <dsaxena@plexity.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Modprobe as script breaks initramfs kernel?
Message-ID: <20070223034458.GB3320@plexity.net>
Reply-To: dsaxena@plexity.net
References: <20070222003309.GA22471@plexity.net> <45DD7EED.7030107@tls.msk.ru> <Pine.LNX.4.61.0702221941290.7553@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702221941290.7553@yvahk01.tjqt.qr>
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 22 2007, at 19:44, Jan Engelhardt was caught saying:
> 
> On Feb 22 2007 14:30, Michael Tokarev wrote:
> >Deepak Saxena wrote:
> >> We attempted an experiment in cleaning up some modprobe messages during 
> >> initramfs bootup when the modules directory is missing by moving modprobe 
> >> to modprobe-bin and replacing modprobe with the following simple shell script:
> >> 
> >> #!/bin/sh
> >> # Clean up bootup when modules are not present
> >> 
> >> if [ -e "/lib/modules/'uname -r'/modules.dep" ] ; then
> >> 	/sbin/modprobe-bin $*
> 
> The nitpick guide says: `uname -r` and "$@" instead of $*  ;-)

Yeah. The quotes were a typo in my email. :)

> >This is the same issue I reported much earlier with /sbin/hotplug being a script
> >in initrfamfs.  The problem is because pipefs isn't initialized yet at the time
> >the script gets called, and causes a NULL-pointer deref.  Obviously you're using
> >pipe above.
> 
> Btw, has this pipefs issue been adressed (by moving pipefs before initramfs
> stage), or something?

If it hasn't, it's now on my todo list.

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net

In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertolt Brecht
