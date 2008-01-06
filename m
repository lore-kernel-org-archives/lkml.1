Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYAFUaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYAFUaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYAFUaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:30:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57739 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041AbYAFUaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:30:10 -0500
Date: Sun, 6 Jan 2008 12:29:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory
 pressure: box ==> doorstop
Message-Id: <20080106122954.d8f04c98.akpm@linux-foundation.org>
In-Reply-To: <1199642470.3927.12.camel@homer.simson.net>
References: <1199447212.4529.13.camel@homer.simson.net>
	<1199612533.4384.54.camel@homer.simson.net>
	<1199642470.3927.12.camel@homer.simson.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jan 2008 19:01:10 +0100 Mike Galbraith <efault@gmx.de> wrote:

> 
> On Sun, 2008-01-06 at 10:42 +0100, Mike Galbraith wrote:
> > FWIW, here's box having same seizure writing to /dev/pktcdvd/sr0.
> 
> Ugh, horrid device IO ==> horrid VM AFIKT.  I'll continue rummaging, but
> I wonder, am I doing something _so_ stupid as to warrant zero response?
> 

Copying linux-mm might have helped.  Bad time of year, too.

>From the traces it looks like all IO has stopped and everyone is waiting
(directly or indirectly) for certain IO completions.  Is that really true,
or is IO still dribbling along?

>From the kswapd0 trace it would appear that UDF is doing synchronous writes
(udf_update_inode->sync_dirty_buffer) which perhaps is making things
mightily slow.

