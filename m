Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYE2Ikz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYE2Ikz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYE2Ikq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:40:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbYE2Ikp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:40:45 -0400
Date: Thu, 29 May 2008 01:40:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Steve French" <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: optimizing out inline functions
Message-Id: <20080529014033.90b0566b.akpm@linux-foundation.org>
In-Reply-To: <84144f020805281254o16c903b6p2c14e5874d5ad67f@mail.gmail.com>
References: <524f69650805281251r1b1d99a1tc3223d15e3aeb50c@mail.gmail.com>
	<84144f020805281254o16c903b6p2c14e5874d5ad67f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 22:54:47 +0300 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On Wed, May 28, 2008 at 10:51 PM, Steve French <smfrench@gmail.com> wrote:
> > Is one or the other style (with or without #define of empty function)
> > preferred?  Does the compiler optimize both #else clauses out
> > properly?  sparse and checkpatch seem to take either
> 
> Both are optimized out but empty function is preferred for type checking.

Plus the inlined function can help suppress unused-var warnings because
it counts as a "use".

Sometimes this works the other way and the argument to the macro/inline
just doesn't exist, in which case we're forced to use a macro for the stub.



