Return-Path: <linux-kernel-owner+w=401wt.eu-S967741AbXEIDaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967741AbXEIDaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967498AbXEIDaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:30:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:47174 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754293AbXEIDaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:30:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18pOThOwvIpGdOIaEwPx1aS94OuaOkvpPEOgX87dC
	z4I/MZnRfkRbe+
Subject: Re: multi-second freezes with current GIT?
From: Mike Galbraith <efault@gmx.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070508.184458.21594839.davem@davemloft.net>
References: <20070508.184458.21594839.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 09 May 2007 05:29:20 +0200
Message-Id: <1178681360.7487.59.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 18:44 -0700, David Miller wrote:
> I've been noticing this off and on for the past week or so.
> 
> The system seems to jam up for several seconds, anything that would
> need to read from disk just sits there during this time.  I think it's
> correlated with generating a lot of dirty write data.
> 
> My mouse moves around in X etc. so it really is only processes that
> need to read from disk that get stuck.
> 
> Perhaps it's a side effect of those dirty ratio changes Linus made to
> start off the 2.6.22 merge cycle?

Uhoh, that seems highly likely.

I think those changes may have been triggered by my repeatable and truly
horrible system stalls when writing to an ext3 data=ordered nearly full
filesystem.  Anything that does fdatasync() and/or fsync() can cause
very bad experiences indeed.  KDE's little menu/program launcher
doohickey does fdatasync() for some odd reason, which has utterly killed
my entire GUI for up to and including 20 minutes at a whack.

Switching to data=writeback cured those horrors.  Lowering the dirty
ratio reduced the agony of data=ordered tremendously, but didn't make it
even remotely acceptable.

	-Mike

