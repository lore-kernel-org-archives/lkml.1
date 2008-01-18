Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYARKnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYARKnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYARKnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:43:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:65381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYARKnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:43:06 -0500
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080118073836.GA1703@ff.dom.local>
References: <20080117194728.GA2598@ami.dom.local>
	 <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>
	 <20080117203155.GA2791@ami.dom.local> <20080117232626.GC2905@ami.dom.local>
	 <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com>
	 <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com>
	 <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com>
	 <1200626323.5640.21.camel@lov.site>
	 <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com>
	 <20080118073836.GA1703@ff.dom.local>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 11:45:12 +0100
Message-Id: <1200653112.8706.21.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+W8C2iPsisxTw0xCooAUYOLMsLk0DJLVwRI7g
 AXm54sUWKMQQMGix/A45g2lkEoCse/z3Map3H+hgtdvHQA1S7m
 k7ZcMk1fyXyXGEccWfxddI+RiiiTKv5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-18 at 08:38 +0100, Jarek Poplawski wrote:
> On Fri, Jan 18, 2008 at 01:31:17PM +0800, Dave Young wrote:
> > On Jan 18, 2008 11:18 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> ...
> > > Yeah, might be better to wait until class_device is gone, otherwise you
> > > may need to fix stuff that is just going to be removed. Your change to
> > > have iterators for the class devices look like a nice preparation for
> > > future changes though.
> > >
> > > Our rough plan is:
> > >  2.6.25:
> > >   - get the ~100 patches in Greg's tree (in -mm) merged :)
> > >  2.6.26:
> > > ???  - remove the 20 char limit in "struct device"
> > >   - get rid of "struct class_device"
> > 
> > Fine, thanks.
> > 
> > Let's wait for other people's comment.
> 
> Dave, I doubt you'll ever manage to do this if you're going to wait:
> probably there will be always some new changes like this around...

Well there are not "changes" in that sense, the class_device stuff will
be entirely ripped out, and I doubt we will want to change anything
there, just shortly before it's deleted.

Also your assumptions about device nesting are not really true, there is
no limit, even when there are no current users nesting deeper, and
"struct device" can be any nesting depth, and that's where it gets
interesting.

Kay

