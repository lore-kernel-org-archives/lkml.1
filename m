Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbXEPThV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbXEPThV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbXEPThL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:37:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756689AbXEPThJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:37:09 -0400
Date: Wed, 16 May 2007 12:33:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-Id: <20070516123342.714a11d8.akpm@linux-foundation.org>
In-Reply-To: <20070516191339.GA26766@think.oraclecorp.com>
References: <20070516144205.GV26766@think.oraclecorp.com>
	<464B2AC2.10206@redhat.com>
	<20070516171156.GY26766@think.oraclecorp.com>
	<20070516112515.b6f247b2.akpm@linux-foundation.org>
	<20070516191339.GA26766@think.oraclecorp.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 15:13:39 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> > 
> > If that's still working then the problem will _probably_ be directory
> > writeout.  Possibly inodes, but they should be well-laid-out.
> > 
> > Were you using dir_index?  That might be screwing things up.
> 
> Yes, dir_index.  A quick test of mkfs.ext3 -O ^dir_index seems to still
> have the problem.  Even though the inodes are well laid out, is the
> order they get written sane?

Should be: it uses first-fit.

>  Looks like ext3 is just walking a list of
> bh/jh, maybe we can just sort the silly thing?

The IO scheduler is supposed to do that.

But I don't know what's causing this.
