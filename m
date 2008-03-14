Return-Path: <linux-kernel-owner+w=401wt.eu-S1759001AbYCNUz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001AbYCNUz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbYCNUzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:55:49 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:57429 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753976AbYCNUzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:55:48 -0400
Date: Fri, 14 Mar 2008 16:55:19 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlo Wood <carlo@alinoe.com>, ext3grep@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [ext3grep] compile error
Message-ID: <20080314205519.GE13733@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Carlo Wood <carlo@alinoe.com>, ext3grep@googlegroups.com,
	linux-kernel@vger.kernel.org
References: <1f45affd0803140826m34d9eee5veb8069e215d55fcf@mail.gmail.com> <20080314170004.GA25174@alinoe.com> <20080314181455.GA15351@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314181455.GA15351@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 02:14:55PM -0400, Christoph Hellwig wrote:
> On Fri, Mar 14, 2008 at 06:00:04PM +0100, Carlo Wood wrote:
> > This seem a bug in linux/ext3_fs.h. I was able to reproduce this on
> > debian sid, meaning kernel (headers) 2.6.24.
> 
> No, the problem is that the tool you're compiling is using kernel
> headers which it shouldn't use at all.  Please use the headers from
> e2fslibs-dev in /usr/include/esxt2fs/ instead.  And yes, they provide
> ext3 defintions despite the ext2 name.

Furthermore, applications are well advised to use libext2fs instead of
trying to roll their own access routines.  Libext2fs has been in
development for over ten years, and as such as all sorts of nice
features, including regression test suites, byte swapping so the code
will work on big-endian systems, portability to non-Linux systems, etc.

Using libext2fs also means that it's much more likely the application
will require less work to support ext4 in the future.  If there's
something that ext3grep needs where some existing libext2fs function
provides almost, but not quite, the needed functionality, talk to me;
right now there's quite a bit of development going on with e2fsprogs,
and it's likely I can add the needed support in the next version of
the library.

Regards,

						- Ted
