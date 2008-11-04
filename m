Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYKDJOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYKDJOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbYKDJNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:13:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100AbYKDJN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:13:27 -0500
Date: Tue, 4 Nov 2008 01:12:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       rwheeler@redhat.com
Subject: Re: [PATCH] improve jbd fsync batching
Message-Id: <20081104011242.cc767dba.akpm@linux-foundation.org>
In-Reply-To: <20081104052428.GP3184@webber.adilger.int>
References: <20081028201614.GA21600@unused.rdu.redhat.com>
	<20081103122729.60582692.akpm@linux-foundation.org>
	<20081104052428.GP3184@webber.adilger.int>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008 22:24:28 -0700 Andreas Dilger <adilger@sun.com> wrote:

> On Nov 03, 2008  12:27 -0800, Andrew Morton wrote:
> > On Tue, 28 Oct 2008 16:16:15 -0400
> > Josef Bacik <jbacik@redhat.com> wrote:
> > > +		spin_lock(&journal->j_state_lock);
> > > +		commit_time = journal->j_average_commit_time;
> > > +		spin_unlock(&journal->j_state_lock);
> > 
> > OK, the lock is needed on 32-bit machines, I guess.
> 
> Should we pessimize the 64-bit performance in that case, for 32-bit
> increasingly rare 32-bit platforms?

In general no.

But spinlocks also do memory ordering stuff on both 32- and 64-bit
machines.  Introducing differences there needs thinking about.

In this case it's fsync which is going to be monster slow anyway.

