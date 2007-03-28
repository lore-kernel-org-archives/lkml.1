Return-Path: <linux-kernel-owner+w=401wt.eu-S965687AbXC1TIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687AbXC1TIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965691AbXC1TIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:08:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:39997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965687AbXC1TIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:08:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/6] i386 - fix cmpxchg warning
Date: Wed, 28 Mar 2007 21:05:03 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
References: <20070327182746.GA8395@c2.user-mode-linux.org>
In-Reply-To: <20070327182746.GA8395@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282105.03832.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  #include <linux/compiler.h>
>  #include <asm/processor.h>
> +#include <asm/system.h>
Sorry no. system.h is the header from hell and putting it into a "basic" header
like atomic_t will likely cause all kinds of problems.

If it's a real issue move cmpxchhg into a different header and include that
from system.h and atomic.h. system.h has too much stuff anyways so it could
use any cleanup.

-Andi
