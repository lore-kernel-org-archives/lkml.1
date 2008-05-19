Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbYESOuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbYESOuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYESOuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:50:07 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40495 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758214AbYESOuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:50:05 -0400
Date: Mon, 19 May 2008 10:46:54 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jamie@shareable.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080519144654.GC15035@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jamie@shareable.org
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <87ej7zcrqv.fsf@basil.nowhere.org> <200805190926.41970.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805190926.41970.chris.mason@oracle.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 09:26:41AM -0400, Chris Mason wrote:
> >
> > Didn't ext4 have some new checksum trick to avoid them?
> 
> I didn't think checksumming avoided barriers completely.  Just the barrier 
> before the commit block, not the barrier after.

Funny thing, I was looking in this over the weekend.  It currently
avoids barriers entirely if journal_async_commit is enabled (which is
not the default); if enabled, it effectively forces barrier=0.  This
is IMHO a bug.

I'm working on a patch where "barrier=1" will use a barrier before and
after, and "barrier=1,journal_async_commit" will use a barrier after.

       	   				    	     - Ted
