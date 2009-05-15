Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbZEOK6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbZEOK6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762611AbZEOK6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:58:23 -0400
Received: from thunk.org ([69.25.196.29]:42646 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762593AbZEOK6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:58:22 -0400
Date: Fri, 15 May 2009 06:58:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: Timo Sirainen <tss@iki.fi>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org
Subject: Re: ext3/ext4 directories don't shrink after deleting lots of files
Message-ID: <20090515105815.GD6816@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Timo Sirainen <tss@iki.fi>,
	Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org
References: <1242338523.6933.664.camel@timo-desktop> <1b7401870905141732v43bd7321g1f0d9721b5e3f761@mail.gmail.com> <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 08:45:38PM -0400, Timo Sirainen wrote:
>
> I was rather thinking something that I could run while the system was  
> fully operational. Otherwise just moving the files to a temp directory + 
> rmdir() + rename() would have been fine too.
>
> I just tested that xfs, jfs and reiserfs all shrink the directories  
> immediately. Is it more difficult to implement for ext* or has no one  
> else found this to be a problem?

It's probably fairest to say no one has thought it worth the effort.
It would require some fancy games to swap out block locations in the
extent trees (life would be easier with non-extent-using inodes), and
in the case of htree, we would have to keep track of the index block
so we could remove it from the htree index.  So it's all doable, if a
bit tricky in terms of the technical details; it's just that the
people who could do it have been busy enough with other things.

It's hasn't been considered high priority because most of the time
directories don't go from holding thousands of files down to a small
handful.  

						- Ted
