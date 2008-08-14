Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYHNXpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYHNXpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYHNXpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:45:06 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40873 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751799AbYHNXpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:45:03 -0400
Date: Thu, 14 Aug 2008 19:44:59 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
Message-ID: <20080814234458.GD13048@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <1218747656.15342.439.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218747656.15342.439.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I spent a bunch of time hammering on different ways to fix this without
> increasing nr_requests, and it was a mixture of needing better tuning in
> btrfs and needing to init mapping->writeback_index on inode allocation.
> 
> So, today's numbers for creating 30 kernel trees in sequence:
> 
> Btrfs defaults                  57.41 MB/s
> Btrfs dup no csum               74.59 MB/s 
> Btrfs no duplication            76.83 MB/s
> Btrfs no dup no csum no inline  76.85 MB/s

What sort of script are you using?  Basically something like this?

for i in `seq 1 30` do
    mkdir $i; cd $i
    tar xjf /usr/src/linux-2.6.28.tar.bz2
    cd ..
done

						- Ted
