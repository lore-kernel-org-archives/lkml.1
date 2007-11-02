Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbXKBM5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbXKBM5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 08:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbXKBM5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 08:57:00 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33620 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753249AbXKBM5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 08:57:00 -0400
Message-ID: <394008222.31766@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 2 Nov 2007 20:56:55 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
References: <20071031035245.GQ25561@iucha.net> <E1In7S9-0001rv-NO@localhost> <20071031121606.GR25561@iucha.net> <20071031175318.GU25561@iucha.net> <E1InUH6-0001vE-1Y@localhost> <20071101122558.GX25561@iucha.net> <E1InZht-0004lr-NN@localhost> <20071101141414.GZ25561@iucha.net> <E1InlPV-0001f1-SL@localhost> <20071102021002.GF25561@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102021002.GF25561@iucha.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1Inw51-0001e8-PS@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 09:10:02PM -0500, Florin Iucha wrote:
> On Fri, Nov 02, 2007 at 09:33:21AM +0800, Fengguang Wu wrote:
> > > I will try that with a USB disk - I hope that won't make a difference.
> > 
> > Thank you. I guess a reiserfs on loop file would also be OK.
> > 
> > > > btw, what's the exact kernel version you are running?
> > > 
> > > I noticed it with the kernel in the $SUBJECT, as reported by 'git
> > > describe'.  I have pulled in new changesets since then.
> > 
> > And with the following patch applied?
> > 
> > ---
> >  fs/reiserfs/stree.c |    3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > --- linux-2.6.24-git17.orig/fs/reiserfs/stree.c
> > +++ linux-2.6.24-git17/fs/reiserfs/stree.c
> > @@ -1458,9 +1458,6 @@ static void unmap_buffers(struct page *p
> >  				}
> >  				bh = next;
> >  			} while (bh != head);
> > -			if (PAGE_SIZE == bh->b_size) {
> > -				cancel_dirty_page(page, PAGE_CACHE_SIZE);
> > -			}
> >  		}
> >  	}
> >  }
> 
> ... and with the above patch applied.
> 
> Copying 300 MB from root (ext3) to the new file system did not trigger
> the pdflush condition.  But then I did a
>    cd $MOUNTPOINT && find . -exec md5sum {} \;
> and that brought one cpu to 75% iowait.

Immediately? Do you have the debug printk messages this time(with the
above patch)?

> I have attached my .config, if it helps.

It's really curious - I tried your .config and commands, and still
could not trigger the high iowait. I'm running 64bit Intel Core 2,
and kernel 2.6.24-rc1-git6 with the above patch.

Fengguang

