Return-Path: <linux-kernel-owner+w=401wt.eu-S1764159AbXGaQD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764159AbXGaQD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXGaQDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:03:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46934 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbXGaQDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:03:20 -0400
Date: Tue, 31 Jul 2007 17:02:48 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: WARN_ON() which sometimes sucks
Message-ID: <20070731160248.GK21089@ftp.linux.org.uk>
References: <20070731155527.GB7253@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731155527.GB7253@localhost.sw.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 07:55:27PM +0400, Alexey Dobriyan wrote:
> It started when I tried to write
> 
> 	WARN_ON(m->seq_ops_allocated);
> 
> in today's "[PATCH] single_open/seq_release leak diagnostics?.
> Suprisingly compiler told me piss off with:
> 
> 	  CC      fs/seq_file.o
> 	fs/seq_file.c: In function 'seq_release':
> 	fs/seq_file.c:285: error: 'typeof' applied to a bit-field
> 
> Well, duh! Earlier versions of WARN_ON allowed that until commit
> 684f978347deb42d180373ac4c427f82ef963171? which added typeof().
> 
> OK, nobody noticed that WARN_ON(bitfield) stopped working. But I
> question the rationale of that commit:

Actually, the real problem is different - WTF do we need that typeof
anyway?
	int ret_warn_on = !!(condition);
	[same as now]
will work just fine...
