Return-Path: <linux-kernel-owner+w=401wt.eu-S1761480AbXHAD5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480AbXHAD5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbXHAD5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:57:12 -0400
Received: from ozlabs.org ([203.10.76.45]:60357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbXHAD5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:57:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18096.949.934194.648312@cargo.ozlabs.ibm.com>
Date: Wed, 1 Aug 2007 13:53:25 +1000
From: Paul Mackerras <paulus@samba.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: WARN_ON() which sometimes sucks
In-Reply-To: <20070731160248.GK21089@ftp.linux.org.uk>
References: <20070731155527.GB7253@localhost.sw.ru>
	<20070731160248.GK21089@ftp.linux.org.uk>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro writes:

> Actually, the real problem is different - WTF do we need that typeof
> anyway?
> 	int ret_warn_on = !!(condition);
> 	[same as now]
> will work just fine...

It will mean more code on architectures which have a
conditional-trap-on-nonzero instruction, such as powerpc, since the
compiler will generate instructions to evaluate !!x.  But I don't see
any reason why ret_warn_on couldn't be a long.

Paul.
