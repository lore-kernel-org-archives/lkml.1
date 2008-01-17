Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYAQNYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYAQNYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYAQNYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:24:32 -0500
Received: from dtp.xs4all.nl ([80.126.206.180]:33099 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750952AbYAQNYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:24:31 -0500
Date: Thu, 17 Jan 2008 14:24:29 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@BitWizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
Subject: Re: [PATCH -v5 2/2] Updating ctime and mtime at syncing
Message-ID: <20080117132429.GB14692@bitwizard.nl>
References: <12005314662518-git-send-email-salikhmetov@gmail.com> <1200531471556-git-send-email-salikhmetov@gmail.com> <E1JFSgG-0006G1-6V@pomaz-ex.szeredi.hu> <4df4ef0c0801170416s5581ae28h90d91578baa77738@mail.gmail.com> <E1JFU7r-0006PK-So@pomaz-ex.szeredi.hu> <4df4ef0c0801170516k3f82dc69ieee836b5633378a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4df4ef0c0801170516k3f82dc69ieee836b5633378a@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 04:16:47PM +0300, Anton Salikhmetov wrote:
> 2008/1/17, Miklos Szeredi <miklos@szeredi.hu>:
> > > > 4. Recording the time was the file data changed
> > > >
> > > > Finally, I noticed yet another issue with the previous version of my patch.
> > > > Specifically, the time stamps were set to the current time of the moment
> > > > when syncing but not the write reference was being done. This led to the
> > > > following adverse effect on my development system:
> > > >
> > > > 1) a text file A was updated by process B;
> > > > 2) process B exits without calling any of the *sync() functions;
> > > > 3) vi editor opens the file A;
> > > > 4) file data synced, file times updated;
> > > > 5) vi is confused by "thinking" that the file was changed after 3).
> >
> > Updating the time in remove_vma() would fix this, no?
> 
> We need to save modification time. Otherwise, updating time stamps
> will be confusing the vi editor.

If process B exits before vi opens the file, the timestamp should at
the latest be the time that process B exits. There is no excuse for
setting the timestamp later than the time that B exits.

If process B no longer modifies the file, but still keeps it mapped
until after vi starts, then the system can't help the
situation. Wether or not B acesses those pages is unknown to the
system. So you get what you deserve.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
