Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYHOBiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYHOBiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 21:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYHOBiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 21:38:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46301 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYHOBiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 21:38:11 -0400
Date: Fri, 15 Aug 2008 03:39:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
Message-ID: <20080815013934.GE19125@one.firstfloor.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <1218747656.15342.439.camel@think.oraclecorp.com> <20080814211756.GC13814@one.firstfloor.org> <1218763554.15342.460.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218763554.15342.460.camel@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The async worker threads should be spreading the load across CPUs pretty
> well, and even a single CPU could keep up with 100MB/s checksumming.
> But, the async worker threads do randomize the IO somewhat because the
> IO goes from pdflush -> one worker thread per CPU -> submit_bio.  So,
> maybe that 3rd thread is more than the drive can handle?

You have more threads with duplication? 

> 
> btrfsck tells me the total size of the btree is only 20MB larger with
> checksumming on.
> 
> > > Btrfs no duplication            76.83 MB/s
> > > Btrfs no dup no csum no inline  76.85 MB/s
> > 
> > But without duplication they are basically free here at least
> > in IO rate. Seems odd?
> > 
> > Does it compute them twice in the duplication case perhaps?
> > 
> 
> The duplication happens lower down in the stack, they only get done
> once.

Ok was just speculation. The big difference still seems odd.

-Andi
