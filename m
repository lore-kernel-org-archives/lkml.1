Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYGJNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYGJNaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYGJNaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:30:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59213 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbYGJNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:30:30 -0400
Subject: Re: Higher than expected disk write(2) latency
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Sustrik <sustrik@fastmq.com>, Martin Lucina <mato@kotelna.sk>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org
In-Reply-To: <20080710011417.95532d51.akpm@linux-foundation.org>
References: <20080628121131.GA14181@nodbug.moloch.sk>
	 <20080709222701.8eab4924.akpm@linux-foundation.org>
	 <4875C45C.2010901@fastmq.com>
	 <20080710011417.95532d51.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 09:29:01 -0400
Message-Id: <1215696541.24425.214.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 01:14 -0700, Andrew Morton wrote:
> On Thu, 10 Jul 2008 10:12:12 +0200 Martin Sustrik <sustrik@fastmq.com> wrote:
> 
> > Hi Andrew,
> > 
> > >> we're getting some rather high figures for write(2) latency when testing
> > >> synchronous writing to disk.  The test I'm running writes 2000 blocks of
> > >> contiguous data to a raw device, using O_DIRECT and various block sizes
> > >> down to a minimum of 512 bytes.  
> > >>
> > >> The disk is a Seagate ST380817AS SATA connected to an Intel ICH7
> > >> using ata_piix.  Write caching has been explicitly disabled on the
> > >> drive, and there is no other activity that should affect the test
> > >> results (all system filesystems are on a separate drive).  The system is
> > >> running Debian etch, with a 2.6.24 kernel.

Is NCQ enabled on the drive?  The basic way to fix this is to have
multiple requests in flight, which isn't going to happen on sata with
the cache off and with ncq off.

So, AIO + NCQ should be fast, as long as your application has multiple
requests in flight through aio (or multiple threads).

-chris


