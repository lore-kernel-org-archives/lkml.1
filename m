Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbZACHNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbZACHNu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACHNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:13:42 -0500
Received: from ozlabs.org ([203.10.76.45]:38255 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZACHNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:13:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.28-mmotm1230 - BUG during 'shutdown -h'
Date: Sat, 3 Jan 2009 17:43:35 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <4491.1230900738@turing-police.cc.vt.edu>
In-Reply-To: <4491.1230900738@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901031743.35578.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009 23:22:18 Valdis.Kletnieks@vt.edu wrote:
> 100% repeatable.  I haven't had a chance to bisect and track this down yet,
> though most of the obvious suspects are in either origin.patch or linux-next.patch
> so a bisect of -mmotm probably won't tell us much.

kernel/workqueue.c: In function ‘wq_cpu_map’:
kernel/workqueue.c:94: warning: pointer type mismatch in conditional expression

That's a problem for a start.  Looks like a merge bug.  Does removing the &
from in front of cpu_populated_map help?

static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
{
	return is_wq_single_threaded(wq)
		 ? get_cpu_mask(singlethread_cpu) : &cpu_populated_map;
}

Cheers,
Rusty.
