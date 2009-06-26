Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbZFZXdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbZFZXdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZFZXdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:33:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55000 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZFZXdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:33:22 -0400
Date: Fri, 26 Jun 2009 22:18:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>
Subject: Q: do_coredump() && d_unhashed()
Message-ID: <20090626201829.GA25976@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180222.GD7337@hmsreliant.think-freely.org> <20090626165908.GB12063@redhat.com> <20090626202411.GH7337@hmsreliant.think-freely.org> <20090626191418.GA22603@redhat.com> <20090626191602.GC22603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626191602.GC22603@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Oleg Nesterov wrote:
>
> do_coredump() does a lot of file checks which are only needed when !ispipe,

I wonder why do we check d_unhashed() after filp_open() ?

Also, we are doing filp_open(O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE), this
2 == O_RDWR looks very strange.

Oleg.

