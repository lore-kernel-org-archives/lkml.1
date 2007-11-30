Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXK3XEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXK3XEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXK3XEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:04:38 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:34690 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755046AbXK3XEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:04:38 -0500
X-YMail-OSG: 4eG2ZXYVM1kE19Y3nwScO.Ibi6Jz3ydL.xqwLH3vvwlLrjWeo_ho9PfOMMwGwA3fkjqpaSv9Gg--
Date: Fri, 30 Nov 2007 15:04:35 -0800
From: Chris Wedgwood <cw@f00f.org>
To: Stephen Lord <lord@xfs.org>
Cc: Timothy Shimmin <tes@sgi.com>, Christoph Hellwig <hch@infradead.org>,
       linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071130230435.GA12626@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org> <474FBA21.4070201@sgi.com> <165B249C-FE97-4B27-927B-B39DE316CB23@xfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165B249C-FE97-4B27-927B-B39DE316CB23@xfs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 04:36:25PM -0600, Stephen Lord wrote:

> Looks like the readdir is in the bowels of the btree code when
> filldir gets called here, there are probably locks on several
> buffers in the btree at this point. This will only show up for large
> directories I bet.

I see it for fairly small directories.  Larger than what you can stuff
into an inode but less than a block (I'm not checking but fairly sure
that's the case).

> Just rambling, not a single line of code was consulted in writing
> this message.

Can you explain why the offset is capped and treated in an 'odd way'
at all?

+       curr_offset = filp->f_pos;
+       if (curr_offset == 0x7fffffff)
+               offset = 0xffffffff;
+       else
+               offset = filp->f_pos;

and later the offset to filldir is masked.  Is that some restriction
in filldir?
