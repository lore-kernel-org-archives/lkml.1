Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYJVUlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYJVUlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYJVUlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:41:00 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38859 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752099AbYJVUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:40:59 -0400
Date: Wed, 22 Oct 2008 16:40:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Yea old defrag
Message-ID: <20081022204053.GA10369@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Phillip Susi <psusi@cfl.rr.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <48FF506F.6060701@cfl.rr.com> <20081022180342.GA26257@mit.edu> <48FF86AC.6060802@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF86AC.6060802@cfl.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 04:01:48PM -0400, Phillip Susi wrote:
>
> I have been trying to identify any new features that cause problems and  
> fix any that arise.  Aren't extended attributes stored in the extra  
> space of large inodes?  If so, I would need to format a new fs using  
> large inodes to test.

Extended attributes *can* be stored in the extra space of large
inodes, but they can also be stored in separate, stand-alone data
blocks --- and just to make life entertaining, if multiple files have
exactly the same set of extended attributes (for example, if all of
the files inone directory have the same ACL and/or SELinux property),
an extended attribute block can be shared across multiple inodes for
space efficiency.

> Are there any other ext3 features that might cause trouble?  I know  
> there are plenty in ext4, but I want to make sure everything works well  
> in ext3 first.

That's probably the main one; and as you say, there are plenty of new
features that will require special handling for e2defrag, especially
since it doesn't use the standard libext2fs library.

						- Ted

