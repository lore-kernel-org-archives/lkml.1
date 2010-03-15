Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab0COFy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:54:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36908
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759685Ab0COFyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:54:22 -0400
Date: Sun, 14 Mar 2010 22:54:43 -0700 (PDT)
Message-Id: <20100314.225443.150715656.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, drepper@redhat.com, torvalds@linux-foundation.org,
       munroesj@linux.vnet.ibm.com
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268630313.2335.2.camel@pasglop>
References: <1268628493.2355.2.camel@pasglop>
	<20100314.220646.190065794.davem@davemloft.net>
	<1268630313.2335.2.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 15 Mar 2010 16:18:33 +1100

> Or is there any good reason -not- to do that in glibc ?

The whole point of syscall() is to handle cases where the C library
doesn't know about the system call yet.

I think it's therefore very much "buyer beware".

On sparc it'll never work to use the workaround you're proposing since
we pass everything in via registers.

So arch knowledge will always need to be present in these situations.
