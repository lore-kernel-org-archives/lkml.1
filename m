Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbZENNRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbZENNRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760864AbZENNRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:17:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:42150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760494AbZENNRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:17:08 -0400
Subject: Re: [PATCH 0/4] x86-64: fix vclock_gettime()
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-x86_64@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       zwane@arm.linux.org.uk, roland@redhat.com
In-Reply-To: <cover.1242299014.git.ptesarik@suse.cz>
References: <cover.1242299014.git.ptesarik@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Thu, 14 May 2009 15:17:07 +0200
Message-Id: <1242307027.19219.6.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik píše v Čt 14. 05. 2009 v 15:06 +0200:
> Now, commit cb9e35dce94a1b9c59d46224e8a94377d673e204 removed
> rdtsc_barrier() from that function, and moved it to
> do_vgettimeofday(). AFAICS the same is also needed for
> vgetns(). So far so good, a one-liner should do, shouldn't it?
> No, it won't do.

Just to make things clear. The vDSO had been broken even before Ingo's
commit, but the commit made the .altinstructions section go away from
vDSO, which made the bug kind of disappear.

I could even argue that the synchronization is not even needed, because
this code path gets used rather often, and nobody has complained so far,
but that's probably not the point...

Petr Tesarik


