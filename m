Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0CHQO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:14:59 -0500
Received: from mail.perches.com ([173.55.12.10]:1504 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab0CHQO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:14:57 -0500
Subject: Re: [PATCH resend] net/sunrpc: Remove uses of NIPQUAD, use %pI4
From: Joe Perches <joe@perches.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       linux-nfs <linux-nfs@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B951BF0.9050403@oracle.com>
References: <1267857980.849.22.camel@Joe-Laptop.home>
	 <4B951BF0.9050403@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 08:14:55 -0800
Message-ID: <1268064895.1925.18.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 10:46 -0500, Chuck Lever wrote:
> Why remove the (void) here, but not in xprtrdma/transport.c?  IMO the 
> (void) cast should be left in place at all three call sites.

I didn't notice it in xprtrdma/transport.c, otherwise I'd've
removed it there too.

When the result is not used, snprintf is most commonly not
cast at all.

(There's a space and a tab in the brackets of the grep string)

$ grep -rP --include=*.[ch] "^[ 	]+snprintf\s*\(" * | wc -l
1301

$ grep -rP --include=*.[ch] "^[ 	]+\(\s*void\s*\)\s*snprintf\s*\(" * | wc -l
9

net/sunrpc/ has 7 of those.

I'll get around to submitting patches for all of them.

