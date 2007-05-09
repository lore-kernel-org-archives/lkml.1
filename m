Return-Path: <linux-kernel-owner+w=401wt.eu-S935081AbXEIGXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081AbXEIGXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934666AbXEIGX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:23:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44454
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934664AbXEIGX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:23:26 -0400
Date: Tue, 08 May 2007 23:23:26 -0700 (PDT)
Message-Id: <20070508.232326.44096869.davem@davemloft.net>
To: efault@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: multi-second freezes with current GIT?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1178681360.7487.59.camel@Homer.simpson.net>
References: <20070508.184458.21594839.davem@davemloft.net>
	<1178681360.7487.59.camel@Homer.simpson.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>
Date: Wed, 09 May 2007 05:29:20 +0200

> On Tue, 2007-05-08 at 18:44 -0700, David Miller wrote:
> > I've been noticing this off and on for the past week or so.
> > 
> > The system seems to jam up for several seconds, anything that would
> > need to read from disk just sits there during this time.  I think it's
> > correlated with generating a lot of dirty write data.
> > 
> > My mouse moves around in X etc. so it really is only processes that
> > need to read from disk that get stuck.
> > 
> > Perhaps it's a side effect of those dirty ratio changes Linus made to
> > start off the 2.6.22 merge cycle?
> 
> Uhoh, that seems highly likely.
> 
> I think those changes may have been triggered by my repeatable and truly
> horrible system stalls when writing to an ext3 data=ordered nearly full
> filesystem.  Anything that does fdatasync() and/or fsync() can cause
> very bad experiences indeed.  KDE's little menu/program launcher
> doohickey does fdatasync() for some odd reason, which has utterly killed
> my entire GUI for up to and including 20 minutes at a whack.
> 
> Switching to data=writeback cured those horrors.  Lowering the dirty
> ratio reduced the agony of data=ordered tremendously, but didn't make it
> even remotely acceptable.

I'm using data=ordered on my partitions too.
