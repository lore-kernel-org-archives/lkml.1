Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbXEIInp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbXEIInp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbXEIIng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:43:36 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643AbXEIIne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:43:34 -0400
Date: Wed, 9 May 2007 01:43:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: efault@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: multi-second freezes with current GIT?
Message-Id: <20070509014328.35d1d087.akpm@linux-foundation.org>
In-Reply-To: <20070508.232326.44096869.davem@davemloft.net>
References: <20070508.184458.21594839.davem@davemloft.net>
	<1178681360.7487.59.camel@Homer.simpson.net>
	<20070508.232326.44096869.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 23:23:26 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Mike Galbraith <efault@gmx.de>
> Date: Wed, 09 May 2007 05:29:20 +0200
> 
> > On Tue, 2007-05-08 at 18:44 -0700, David Miller wrote:
> > > I've been noticing this off and on for the past week or so.
> > > 
> > > The system seems to jam up for several seconds, anything that would
> > > need to read from disk just sits there during this time.  I think it's
> > > correlated with generating a lot of dirty write data.
> > > 
> > > My mouse moves around in X etc. so it really is only processes that
> > > need to read from disk that get stuck.
> > > 
> > > Perhaps it's a side effect of those dirty ratio changes Linus made to
> > > start off the 2.6.22 merge cycle?
> > 
> > Uhoh, that seems highly likely.
> > 
> > I think those changes may have been triggered by my repeatable and truly
> > horrible system stalls when writing to an ext3 data=ordered nearly full
> > filesystem.  Anything that does fdatasync() and/or fsync() can cause
> > very bad experiences indeed.  KDE's little menu/program launcher
> > doohickey does fdatasync() for some odd reason, which has utterly killed
> > my entire GUI for up to and including 20 minutes at a whack.
> > 
> > Switching to data=writeback cured those horrors.  Lowering the dirty
> > ratio reduced the agony of data=ordered tremendously, but didn't make it
> > even remotely acceptable.
> 
> I'm using data=ordered on my partitions too.


does

echo 40 > /proc/sys/vm/dirty_ratio
echo 10 > /proc/sys/vm/dirty_background_ratio

fix it?
