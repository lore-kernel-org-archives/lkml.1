Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbYAEJbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbYAEJbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYAEJbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:31:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34054 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbYAEJbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:31:06 -0500
Date: Sat, 5 Jan 2008 01:31:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Timothy Shimmin <tes@sgi.com>
Subject: Re: Why is deleting (or reading) files not counted as IO-Wait in
 top?
Message-Id: <20080105013115.217a5ab1.akpm@linux-foundation.org>
In-Reply-To: <20080102193503.GA31414@citd.de>
References: <20080102193503.GA31414@citd.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008 20:35:03 +0100 Matthias Schniedermeyer <ms@citd.de> wrote:

> Hi
> 
> 
> Currently i'm deleting about 500.000 files on a XFS-filesystem which 
> takes a few minutes, as i had a top open i saw that 'wa' is shown as 
> 0.0% (Nothing else running currently) and everything except 'id' is near 
> the bottom too. Kernel is 2.6.23.11.
> 
> So, as 'rm -rf' is essentially a IO (or seek, to be more correct)-bound 
> task, shouldn't that count as "Waiting for IO"?
> 
> The man-page of top says:
> 'Amount of time the CPU has been waiting for I/O to complete.'
> 
> But AFAICT wa only seams to be (ac)counted for writing and not for 
> reading. I come to that conclusion because, when i fire 'sync' i can see 
> some percent wa for a few seconds.
> 

Yes, you would absolutely expect `rm' to be stuck in D state and
contributing to both load average and io-wait in this situation.

I'd think that either XFS is playing games (and it'd take some pretty
inventive games to do this) or your observations are in error.
