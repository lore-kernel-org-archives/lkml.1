Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZA1SPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZA1SPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZA1SPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:15:37 -0500
Received: from waste.org ([66.93.16.53]:37142 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZA1SPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:15:36 -0500
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
From: Matt Mackall <mpm@selenic.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-api@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20090128175541.GA7074@infradead.org>
References: <20090115153211.663df310@bike.lwn.net>
	 <20090122065104.2787df2d.akpm@linux-foundation.org>
	 <20090122203248.GA20159@infradead.org>
	 <20090123045646.GK15750@one.firstfloor.org>
	 <20090127165504.53ed7a2d.akpm@linux-foundation.org>
	 <20090128031439.GA11025@redhat.com> <20090128173618.GA3174@infradead.org>
	 <20090128104414.09aee3f9@bike.lwn.net>
	 <20090128175541.GA7074@infradead.org>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 12:13:47 -0600
Message-Id: <1233166427.5202.907.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 12:55 -0500, Christoph Hellwig wrote:
> On Wed, Jan 28, 2009 at 10:44:14AM -0700, Jonathan Corbet wrote:
> > If others disagree, and using bitops is not an idea which will fly, I'd
> > sure like to know sooner rather than later.
> 
> There are more than enough use cases that have large numbers of open
> files (e.g. various high-end network servers).  While it might not be
> as sewer as for inodes I think it's really bad idea to do it for no
> reason. 

Maybe we can just demote f_ep_lock to f_lock and share it? 

Or extend flags and have two independent bitlocks in it. This actually
shrinks struct_file for most users.

-- 
http://selenic.com : development and support for Mercurial and Linux


