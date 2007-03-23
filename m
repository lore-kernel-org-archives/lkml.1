Return-Path: <linux-kernel-owner+w=401wt.eu-S2992449AbXCWQDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992449AbXCWQDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992482AbXCWQDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:03:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32852 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992449AbXCWQDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:03:00 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] DVB: Delete unused header file
	linux/dvb/version.h.
From: Arjan van de Ven <arjan@infradead.org>
To: Marcel Siegert <mws@linuxtv.org>
Cc: v4l-dvb-maintainer@linuxtv.org, "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <200703231647.53780.mws@linuxtv.org>
References: <Pine.LNX.4.64.0703231130480.30201@CPE00045a9c397f-CM001225dbafb6>
	 <200703231647.53780.mws@linuxtv.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 23 Mar 2007 17:02:44 +0100
Message-Id: <1174665764.1158.241.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 16:47 +0100, Marcel Siegert wrote:
> On Friday 23 March 2007, Robert P. J. Day wrote:
> > 
> > Delete the unreferenced header file include/linux/dvb/version.h.
> > 
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > 
> NACK
> this header is unreferenced in kernel, but used for applications that compile for userspace
> to determine the api version.


btw that is something extremely evil to do. Either you have varying apis
between kernels (which is naughty, but I suppose you can go up in
capabilities) or it's fully static. 

If it's dynamic, doing it compiletime is BAD. The same binaries should
run on multiple kernels after all. An ioctl or a sysfs thing or
something is a lot better than a compile time constant.

If it's entirely static exposing a "version" doesn't mean anything and
it might as well be killed...

Greetings,
   Arjan van de Ven

