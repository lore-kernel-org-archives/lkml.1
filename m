Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYEROcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYEROcD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 10:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYEROby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 10:31:54 -0400
Received: from ozlabs.org ([203.10.76.45]:33049 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYERObx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 10:31:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
Date: Mon, 19 May 2008 00:31:44 +1000
User-Agent: KMail/1.9.9
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
References: <482C9FC5.2070508@cosmosbay.com> <200805171533.46295.rusty@rustcorp.com.au> <482E8AF5.9050804@cosmosbay.com>
In-Reply-To: <482E8AF5.9050804@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805190031.45136.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 May 2008 17:36:21 Eric Dumazet wrote:
> Christoph Lameter made good work last year and apparently the path is to :
>
> 1) Put pda at the begining of percpu section.

Well, we killed the pda on i386: it's basically a limited arch-specific percpu 
section.  Unfortunately, ISTR that doing so kills -fstack-protector on x86-64 
(gcc was explicitly patched to support the kernel doing this, but it nailed 
us to a fixed offset off %fs).  But the PDA is a redundant idea which should 
be removed.

> 2) Relocate percpu variables to begin at zero
> 3) Use %gs (or %fs) register to address pda AND percpu section.

Thanks for the prod Eric.  ISTR acking those patches; Christoph, what happened 
to them?

Cheers,
Rusty.
