Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZANEYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZANEYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZANEYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:24:11 -0500
Received: from THUNK.ORG ([69.25.196.29]:35337 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZANEYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:24:09 -0500
Date: Tue, 13 Jan 2009 23:24:02 -0500
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Arthur Jones <ajones@riverbed.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "sct@redhat.com" <sct@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Message-ID: <20090114042402.GH14730@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081218231707.GB20092@atrey.karlin.mff.cuni.cz> <496D1233.2060905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496D1233.2060905@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 04:14:11PM -0600, Eric Sandeen wrote:
> 
> This looks sane to me, and it does fix the below testcase.
> 
> Care to formally propose it?

Can we confirm what is being proposed?  From following this thread, I
think what folks are suggesting is:

1)  Revert the current "ext3/4: wait on all pending ocmmits in ext3/4_sync_fs"

2)  Apply Jan's patch "jbd[2]: Fix return value of journal_start_commit()"

3)  Also apply Jan's patch "jbd2: Skip commit of a transaction without
any buffers" since it appears to be a good optimization (although it's
not clear it would happen once we revert (1), above.

    	     	   	       	  	      - Ted
