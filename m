Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbYGQN7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbYGQN7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbYGQN73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:59:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbYGQN72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:59:28 -0400
Date: Thu, 17 Jul 2008 09:40:03 -0400
From: Josef Bacik <jbacik@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
       sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
       Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Message-ID: <20080717134003.GA14133@unused.rdu.redhat.com>
References: <19f34abd0807170551q4fbb862bu270297cfd76a69be@mail.gmail.com> <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com> <19f34abd0807170620g39ab942bl592ea3fa3fa0dab@mail.gmail.com> <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com> <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 03:39:24PM +0200, Vegard Nossum wrote:
> On Thu, Jul 17, 2008 at 3:34 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> >> Yeah, the full log exists at
> >>
> >>    http://folk.uio.no/vegardno/linux/log-1216293934.txt
> >>
> >> I think this is the interesting part:
> >
> > Hmm well the journal should have aborted, but it looks like it didn't,
> > are you mounting with errors=continue by any chance?  Thanks much,
> 
> No, this is the command I used:
> 
>         mount -o loop disk mnt
> 
> I think this looks interesting:
> 
> EXT3-fs error (device loop0) in ext3_reserve_inode_write: IO failure
> 
> The code in ext3_reserve_inode_write() is here:
> 
>         err = ext3_journal_get_write_access(handle, iloc->bh);
>         if (err) {
>                 brelse(iloc->bh);
>                 iloc->bh = NULL;
>         }
> 
> Maybe it should do something different here?
> 
> But I don't know :-)
> 
> Thanks for helping out!
>

Well this is really odd, after that we call ext3_std_error which calls
journal_abort, so when we come into journal_dirty_metadata is_handle_aborted()
should have returned 1 and we should have just exited.  I'm going to have to
think on this for a bit.

Josef 
