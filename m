Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXDDRnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXDDRnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXDDRnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:43:05 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49415 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbXDDRnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:43:01 -0400
Date: Wed, 4 Apr 2007 10:42:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Dillow <dave@thedillows.org>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, ray-gmail@madrabbit.org,
       amanda-hackers@amanda.org, amanda-users@amanda.org
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
Message-Id: <20070404104219.40e25b6a.akpm@linux-foundation.org>
In-Reply-To: <20070404084530.GB1556@elte.hu>
References: <200704010100.19016.gene.heskett@verizon.net>
	<2c0942db0704010033r61f967c3y7d05e3ec0a9f6931@mail.gmail.com>
	<200704011141.53105.gene.heskett@verizon.net>
	<200704020021.02393.gene.heskett@gmail.com>
	<1175488272.3161.28.camel@obelisk.thedillows.org>
	<1175661256.31439.23.camel@obelisk.thedillows.org>
	<20070404084530.GB1556@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 10:45:30 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Dave Dillow <dave@thedillows.org> wrote:
> 
> > > Then it is a matter of figuring out why the device number changed -- 
> > > I'm thinking it is device-mapper, but will look closer tomorrow.
> > 
> > This commit is the one that changed it:
> > 
> > commit fdf892be32d84a1745fa0aee5fc60517421b8038
> > Author: Andrew Morton <akpm@osdl.org>
> > Date:   Mon Feb 12 00:51:44 2007 -0800
> > 
> >     [PATCH] register_blkdev(): don't hand out the LOCAL/EXPERIMENTAL majors
> >     
> >     As pointed out in http://bugzilla.kernel.org/show_bug.cgi?id=7922, 
> >     dynamic blockdev major allocation can hand out majors which LANANA 
> >     has defined as being for local/experimental use.
> 
> i dont think we should break backwards compatibility with a system that 
> has not changed any hardware. Andrew, should we revert this?

Well that's an odd thing for a backup program to be doing - there are any
number of things which could cause a dynamically-allocated major to change.

ho hum, yes, I guess it needs to go.
