Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYA1FQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYA1FQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYA1FQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:16:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35119 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbYA1FQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:16:04 -0500
Date: Sun, 27 Jan 2008 21:13:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Steve French <smfrench@gmail.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Message-Id: <20080127211345.6e73fa0b.akpm@linux-foundation.org>
In-Reply-To: <200801280538.25345.ak@suse.de>
References: <20080127317.043953000@suse.de>
	<200801280358.14024.ak@suse.de>
	<1201493589.8132.7.camel@heimdal.trondhjem.org>
	<200801280538.25345.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 05:38:25 +0100 Andi Kleen <ak@suse.de> wrote:

> On Monday 28 January 2008 05:13:09 Trond Myklebust wrote:
> > 
> > On Mon, 2008-01-28 at 03:58 +0100, Andi Kleen wrote:
> > > The problem is that it's not a race in who gets to do its thing first, but a 
> > > parallel reader can actually see a corrupted value from the two independent 
> > > words on 32bit (e.g. during a 4GB). And this could actually completely corrupt 
> > > f_pos when it happens with two racing relative seeks or read/write()s
> > > 
> > > I would consider that a bug.
> > 
> > I disagree. The corruption occurs because this isn't a situation that is
> > allowed by either POSIX or SUSv2/v3. Exactly what spec are you referring
> > to here?
> 
> No specific spec, just general quality of implementation.

I completely agree.  If one thread writes A and another writes B then the
kernel should record either A or B, not ((A & 0xffffffff00000000) | (B &
0xffffffff))
