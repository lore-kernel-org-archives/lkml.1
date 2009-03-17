Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbZCQWKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbZCQWKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbZCQWJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:09:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:35096 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569AbZCQWJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:09:18 -0400
Subject: Re: Large write = large latency for small writes
From: Peter Zijlstra <peterz@infradead.org>
To: David Rees <drees76@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <72dbd3150903171319u567fc267m36857506c024315d@mail.gmail.com>
References: <72dbd3150903171319u567fc267m36857506c024315d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 23:09:12 +0100
Message-Id: <1237327752.5189.1119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 13:19 -0700, David Rees wrote:

> I have a simple test case which demonstrates the huge increase in
> write latency that occurs for small writes when a large disk
> saturating write is also in progress [3]:
> 
> dd if=/dev/zero of=/tmp/bigfile bs=1M count=10000 conv=fdatasync &
> sleep 10
> time dd if=/dev/zero of=/tmp/smallfile bs=4k count=1 conv=fdatasync
> 
> On a handful of systems I have access to, it took anywhere from 6-45
> seconds for the small write to complete.  Others in the bug have
> reproduced this across a number of filesystems (ext3, reiserfs, ext4).
> xfs in particular seems to handle this test case better than the
> others.  As do systems which can sustain high write speeds.

How does it fare without the fdatasync?

That is, is it the sync that's taking ages, or the ditry?

