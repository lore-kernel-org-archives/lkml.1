Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbXHVTsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbXHVTsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760013AbXHVTsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:48:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760275AbXHVTsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:48:09 -0400
Date: Wed, 22 Aug 2007 12:47:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: jason.wessel@windriver.com, amitkale@linsyssoft.com,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, kgdb-bugreport@lists.sourceforge.net
Subject: Re: 2.6.23-rc3-mm1: kgdb build failure on powerpc
Message-Id: <20070822124743.fc316963.akpm@linux-foundation.org>
In-Reply-To: <200708222104.29432.m.kozlowski@tuxland.pl>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<200708222104.29432.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 21:04:28 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	Got that on imac g3.
> 
>   CC      kernel/kgdb.o
> kernel/kgdb.c: In function 'kgdb_handle_exception':
> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
> kernel/kgdb.c:940: warning: type defaults to 'int' in declaration of '_o_'
> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
> kernel/kgdb.c:940: warning: type defaults to 'int' in declaration of '_n_'
> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
> kernel/kgdb.c:940: warning: type defaults to 'int' in declaration of 'type name'
> make[1]: *** [kernel/kgdb.o] Blad 1
> make: *** [kernel] Blad 2
> 

I'm not surprised.

	while (cmpxchg(&atomic_read(&debugger_active), 0, (procid + 1)) != 0) {

a) cmpxchg isn't available on all architectures

b) we can't just go and take the address of atomic_read()'s return value!

c) that's pretty ugly-looking stuff anyway.
