Return-Path: <linux-kernel-owner+w=401wt.eu-S1761724AbZANPxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761724AbZANPxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZANPx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:53:26 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:13406 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZANPxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:53:25 -0500
Message-ID: <496E0A73.9030903@hp.com>
Date: Wed, 14 Jan 2009 10:53:23 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Pierre Habouzit <pierre.habouzit@intersec.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: if backlog is 0, listening shall not be deactivated.
References: <1231926123-26196-1-git-send-email-pierre.habouzit@intersec.com>	<496DE5ED.8030609@hp.com>	<20090114132124.15b68481@lxorguk.ukuu.org.uk>	<496DEA60.2080700@hp.com> <20090114152133.675da27b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090114152133.675da27b@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> SCTP API simply chooses to ignore the "may".  It is still fully compliant
>> with POSIX in this regard.
> 
> Linux chooses the interpretation that zero means one connection. Having a
> single protocol variant do different things is not nice because  a lot
> of code is designed to handle multiple address families and expect the
> same non address handling behaviour.
> 
> So while it may be able to claim posix compliance, its not Linux
> behaviour, and its relying on a specific interpretation of posix not
> being used by the OS.
> 
> At the very least the current behaviour of the SCTP code is plain rude.
> 

I will submit a requirest to change this behavior in the spec, but I am not
terribly optimistic.  This has been specified for a very long time and there
might be applications taking advantage of the ability to shut listing off.

At this time, let's leave this as is.  A well written application should specify
the listen backlog anyway, otherwise it's depending on the "may" language in the
Posix spec and will not get consistent behavior across different systems.

-vlad
