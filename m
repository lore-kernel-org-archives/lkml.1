Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbYFDSci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbYFDSci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbYFDSc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:32:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757415AbYFDSc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:32:29 -0400
Date: Wed, 4 Jun 2008 11:19:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
       adilger@sun.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
       tytso@mit.edu, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
 buffers
Message-Id: <20080604111911.c1fe09c6.akpm@linux-foundation.org>
In-Reply-To: <20080604101925.GB16572@duck.suse.cz>
References: <4843CE15.6080506@hitachi.com>
	<4843CEED.9080002@hitachi.com>
	<20080603153050.fb99ac8a.akpm@linux-foundation.org>
	<20080604101925.GB16572@duck.suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 12:19:25 +0200 Jan Kara <jack@suse.cz> wrote:

> On Tue 03-06-08 15:30:50, Andrew Morton wrote:
> > On Mon, 02 Jun 2008 19:43:57 +0900
> > Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:
> > 
> > > 
> > > In ordered mode, we should abort journaling when an I/O error has
> > > occurred on a file data buffer in the committing transaction.
> > 
> > Why should we do that?
>   I see two reasons:
> 1) If fs below us is returning IO errors, we don't really know how severe
> it is so it's safest to stop accepting writes. Also user notices the
> problem early this way. I agree that with the growing size of disks and
> thus probability of seeing IO error, we should probably think of something
> cleverer than this but aborting seems better than just doing nothing.
> 
> 2) If the IO error is just transient (i.e., link to NAS is disconnected for
> a while), we would silently break ordering mode guarantees (user could be
> able to see old / uninitialized data).
> 

Does any other filesystem driver turn the fs read-only on the first
write-IO-error?

It seems like a big policy change to me.  For a lot of applications
it's effectively a complete outage and people might get a bit upset if
this happens on the first blip from their NAS.

<waves vigorously at linux-ext4 people>
