Return-Path: <linux-kernel-owner+w=401wt.eu-S933281AbYETUjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbYETUjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbYETUiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:38:52 -0400
Received: from 1wt.eu ([62.212.114.60]:4631 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759084AbYETUiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:38:51 -0400
Date: Tue, 20 May 2008 22:38:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080520203833.GA6749@1wt.eu>
References: <4829D345.7020909@t-online.de> <19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com> <482B1BD2.8040400@t-online.de> <19f34abd0805141017g26c13e96t2e7edc23bec263d0@mail.gmail.com> <20080514183558.40178fe5@core> <48306DCA.9070108@t-online.de> <20080518185104.0a539f25@core> <48331FFF.5070300@t-online.de> <alpine.DEB.1.10.0805201211390.4804@asgard.lang.hm> <483333E8.1090200@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483333E8.1090200@t-online.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 10:26:16PM +0200, Harald Dunkel wrote:
> david@lang.hm wrote:
> >
> >try killing syslog and then see if you continue to have the problem. 
> >It's possible that what's happening is syslog is getting stuck and su is 
> >sitting waiting for syslog to process the log entry.
> >
> 
> No improvement: I killed syslogd, and yet stty gets stuck.
> 
> But surely it was a smart idea.

have you checked in /proc/$(pidof stty)/fd/ to see if stty is bound to
any particular file descriptor ? Maybe you'll find the source of the
blocking operation here. You can find a unix socket attached to
another process, it may be a tty, a pipe, or even a device (eg:
/dev/random when there is no entropy left). Same for "su" BTW.

Regards,
willy

