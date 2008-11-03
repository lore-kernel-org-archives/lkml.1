Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYKCWsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYKCWsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYKCWsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:48:12 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44059 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752509AbYKCWsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:48:11 -0500
Date: Mon, 3 Nov 2008 17:47:55 -0500
From: Theodore Tso <tytso@mit.edu>
To: Arthur Jones <ajones@riverbed.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "sct@redhat.com" <sct@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Message-ID: <20081103224755.GG18117@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"sandeen@redhat.com" <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org> <20081103214840.GA3371@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103214840.GA3371@ajones-laptop.nbttech.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 01:48:40PM -0800, Arthur Jones wrote:
> > - should we clear s_dirt if log_wait_commit() didn't work?
> > 
> > - ext3_force_commit() clears s_dirt also
> 
> I'm not sure if it makes sense, but ATM I don't think it
> hurts anything given that ext3_write_super is just sb->s_dirt = 0;

I want to look at this some more, but it's possible we should just
remove all of the references to sb->s_dirt completely.  Also, the
comment just above ext[34]_write_super() is out of date since before
2.6.0.

						- Ted
