Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYAYG0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYAYG0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 01:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYAYG0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 01:26:44 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:50849 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055AbYAYG0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 01:26:43 -0500
To: taka@valinux.co.jp
Cc: agk@redhat.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 0/2] dm-band: The I/O bandwidth controller:
 Overview
In-Reply-To: Your message of "Thu, 24 Jan 2008 19:14:56 +0900 (JST)"
	<20080124.191456.119427875.taka@valinux.co.jp>
References: <20080124.191456.119427875.taka@valinux.co.jp>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080125062642.05E231E3C0C@siro.lan>
Date: Fri, 25 Jan 2008 15:26:41 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> > > > On Wed, Jan 23, 2008 at 09:53:50PM +0900, Ryo Tsuruta wrote:
> > > > > Dm-band gives bandwidth to each job according to its weight, 
> > > > > which each job can set its own value to.
> > > > > At this time, a job is a group of processes with the same pid or pgrp or uid.
> > > > 
> > > > It seems to rely on 'current' to classify bios and doesn't do it until the map
> > > > function is called, possibly in a different process context, so it won't
> > > > always identify the original source of the I/O correctly:
> > > 
> > > Yes, this should be mentioned in the document with the current implementation
> > > as you pointed out.
> > > 
> > > By the way, I think once a memory controller of cgroup is introduced, it will
> > > help to track down which cgroup is the original source.
> > 
> > do you mean to make this a part of the memory subsystem?
> 
> I just think if the memory subsystem is in front of us, we don't need to
> reinvent the wheel.
> 
> But I don't have a concrete image how the interface between dm-band and
> the memory subsystem should be designed yet. I'd be appreciate if some of
> the cgroup developers give some ideas about it.

the current implementation of memory subsystem associates pages to
cgroups directly, rather than via tasks.  so it isn't straightforward to
use the information for other classification mechanisms like yours which
might not share the view of "hierarchy" with the memory subsystem.

YAMAMOTO Takashi

> 
> Thanks,
> Hirokazu Takahashi.
> 
> 
> > YAMAMOTO Takashi
