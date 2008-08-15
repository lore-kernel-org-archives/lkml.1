Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbYHOEcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbYHOEcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 00:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbYHOEb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 00:31:58 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:53128 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYHOEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 00:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=obHPBID7lx7ECjc+8fQi2iIGJtAbj8Nj0dJDlpdLdue8cVMkE7oCvY7vSXecYpD9+Y
         pUEJS9Lp28DFIAn8zMk67Rv0i/uwcjfup3725Lbuo6+8D/tdeWGEfrGpUTp2i6uXCrpv
         pakyan5XOJw9vVjZ9a+jh7F/KBU4XJUG5TIhU=
Subject: Re: [PATCH 1/3] relay: Fix 4 off-by-one errors occuring when
	writing to a CPU buffer.
From: Tom Zanussi <tzanussi@gmail.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
In-Reply-To: <20080814163504.GA5478@localhost>
References: <20080613040947.7465b9a5@linux360.ro>
	 <1213418437.8237.51.camel@charm-linux>
	 <20080614175223.4d3c6084@linux360.ro>
	 <1213593748.7744.34.camel@charm-linux>
	 <20080621050632.4a7a6c16@linux360.ro>
	 <1216876176.6392.38.camel@charm-linux> <20080730174821.GA5222@localhost>
	 <1218608219.8980.92.camel@charm-linux>  <20080814163504.GA5478@localhost>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 23:31:32 -0500
Message-Id: <1218774692.9943.19.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2008-08-14 at 19:35 +0300, Eduard - Gabriel Munteanu wrote:

> BTW, did the kmemtrace user app work for you? Pekka seemed to have
> issues with compiling it.
> 

Just a small problem compiling - there was no Makefile or configure, and
the README doesn't say anything about autogen.sh, though I later saw
something about it in the kernel documentation.  Anyway, autogen.sh
failed because I didn't have autoconf/automake installed; after doing
that I didn't have a problem compiling.  I did notice a couple printf
format warnings, though.

I then ran kmemtraced and ran the check and report on the output.  The
check passed but the report tool just spewed a lot of error lines with
the same caller.  I looked a little closer and realized there was
something really wrong with the reporting tool e.g. a tiny trace of
about 10k, probably fewer than 200 events (a hexdump of the data looked
ok to me), produced a report of about 800k.  Remembering the printf
format warnings, I realized it probably hadn't been run on a 32-bit
system lately, so I tried it all again on a 64-bit system, and there it
seemed to work ok, or at least the output looked reasonable, to my
untrained eye.

Tom



