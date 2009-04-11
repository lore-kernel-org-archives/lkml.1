Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZDKGRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZDKGRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 02:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbZDKGQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 02:16:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655AbZDKGQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 02:16:45 -0400
Date: Fri, 10 Apr 2009 23:11:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Marton Balint <cus@fazekas.hu>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for April 9
Message-Id: <20090410231158.33b85dc1.akpm@linux-foundation.org>
In-Reply-To: <20090409163305.8c7a0371.sfr@canb.auug.org.au>
References: <20090409163305.8c7a0371.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 16:33:05 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

It has a link failure with i386 allmodconfig due to missing __divdi3.

It's due to this statement in drivers/media/video/cx88/cx88-dsp.c's
int_goertzel():

        return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
                      (s64)coeff*s_prev2*s_prev/32768)/N/N);

that gem will need to be converted to use div64() or similar, please.
