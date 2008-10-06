Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYJFDn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYJFDn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 23:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYJFDnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 23:43:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYJFDnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 23:43:18 -0400
Date: Sun, 5 Oct 2008 23:42:58 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: david@lang.hm
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: application syncing options (was Re: [PATCH] Memory management
 livelock)
In-Reply-To: <alpine.DEB.1.10.0810051714330.17288@asgard.lang.hm>
Message-ID: <Pine.LNX.4.64.0810052332040.3074@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org> <200810031232.23836.nickpiggin@yahoo.com.au>
 <200810031254.29121.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0810030845070.14680@asgard.lang.hm>
 <Pine.LNX.4.64.0810052002520.5798@hs20-bc2-1.build.redhat.com>
 <alpine.DEB.1.10.0810051714330.17288@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, david@lang.hm wrote:

> On Sun, 5 Oct 2008, Mikulas Patocka wrote:
> 
> > On Fri, 3 Oct 2008, david@lang.hm wrote:
> > 
> > > I've also seen discussions of how the
> > > kernel filesystem code can do ordered writes without having to wait for
> > > them
> > > with the use of barriers, is this capability exported to userspace? if so,
> > > could you point me at documentation for it?
> > 
> > It isn't. And it is good that it isn't --- the more complicated API, the
> > more maintenance work.
> 
> I can understand that most software would not want to deal with complications
> like this, but for things thta have requirements similar to journaling
> filesystems (databases for example) it would seem that there would be
> advantages to exposing this capabilities.
> 
> David Lang

If you invent new interface that allows submitting several ordered IOs 
from userspace, it will require excessive maintenance overhead over long 
period of time. So it should be only justified, if the performance 
improvement is excessive as well.

It should not be like "here you improve 10% performance on some synthetic 
benchmark in one application that was rewritten to support the new 
interface" and then create a few more security vulnerabilities (because of 
the complexity of the interface) and damage overall Linux progress, 
because everyone is catching bugs in the new interface and checking it for 
correctness.

Mikulas
