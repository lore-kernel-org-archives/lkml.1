Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394Ab0AROue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0AROue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361Ab0AROud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:50:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:33592 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab0AROud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:50:33 -0500
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Gleb Natapov <gleb@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
References: <20100118133755.GG30698@redhat.com>
	 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
	 <20100118141938.GI30698@redhat.com>
	 <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 15:49:58 +0100
Message-ID: <1263826198.4283.600.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 14:32 +0000, Alan Cox wrote:
> > this kind of control. As of use of mlockall(MCL_FUTURE) how can I make
> > sure that all memory allocated behind my application's back (by dynamic
> > linker, libraries, stack) will be locked otherwise?
> 
> If you add this flag you can't do that anyway - some library will
> helpfully start up using it and then you are completely stuffed or will
> be back in two or three years adding MLOCKALL_ALWAYS.

Agreed, mlockall() is a very bad interface and should not be used for a
plethora of reasons, this being one of them.

The thing is, if you cant trust your library to do sane things, then
don't use it.

