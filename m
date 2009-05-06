Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbZEFROe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbZEFROe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759373AbZEFROH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:14:07 -0400
Received: from verein.lst.de ([213.95.11.210]:54687 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZEFROF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:14:05 -0400
Date: Wed, 6 May 2009 19:13:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, cbe-oss-dev@ozlabs.org,
       srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sputrace: use the generic event tracer
Message-ID: <20090506171326.GA11199@lst.de>
References: <20090506102918.GA23278@lst.de> <20090506105748.GE25203@elte.hu> <20090506165336.GC5997@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506165336.GC5997@nowhere>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 06:53:37PM +0200, Frederic Weisbecker wrote:
> I don't know much the code you are tracing. But it is rare that
> a const char * is safe on tracing. Still it could be, you just have to
> ensure the string cannot be freed in any way because this pointer
> will be stored in the ring buffer and it can be read and dereferenced later
> in a random time, could be several years :-)
> 
> So if this pointer references built-in data, no problem with that.
> But if it can freed (comes from a module, __initdata, ...), then
> you should use the __string() field which does an strcpy on the
> ring buffer.
> 
> If you think this is safe, then it's the best choice because
> storing a pointer is of course less costly than an strcpy.
> If so I will add the support for char * in the filters (trivial).

The pointer here only ever references string constants, it's always
a string literal in the callers.

