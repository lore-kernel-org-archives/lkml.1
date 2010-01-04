Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288Ab0ADHdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0ADHdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 02:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235Ab0ADHdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 02:33:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0ADHdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 02:33:40 -0500
Date: Mon, 4 Jan 2010 02:33:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH v3] readahead: introduce O_RANDOM for
	POSIX_FADV_RANDOM
Message-ID: <20100104073328.GA3422@infradead.org>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20100104045020.GA21021@localhost> <20100104161719.a0bb35ad.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104161719.a0bb35ad.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 04:17:19PM +1100, Stephen Rothwell wrote:
> > @@ -80,6 +80,10 @@
> >  #define O_NDELAY	O_NONBLOCK
> >  #endif
> >  
> > +#ifndef O_RANDOM
> > +#define O_RANDOM	010000000	/* random access pattern hint */
> > +#endif
> 
> This value conflicts with O_CLOEXEC on alpha and parisc and O_NOATIME on
> sparc.

Also when I tried to use this value for O_RSYNC and tested it I could
not actually see it getting propagated by the open code.

Eitherway I don't think an O_ value is a good idea for a simple access
pattern hint.

