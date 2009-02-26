Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZBZMUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZBZMUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZBZMUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:20:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZBZMUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:20:23 -0500
Subject: Re: [PATCH] cpuacct: add a branch prediction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
References: <49A6475F.4000502@cn.fujitsu.com>
	 <20090226170738.a982057b.kamezawa.hiroyu@jp.fujitsu.com>
	 <49A6501B.7040604@cn.fujitsu.com>
	 <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
	 <49A65455.4030204@cn.fujitsu.com>
	 <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
	 <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
	 <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
	 <1235645076.4645.4781.camel@laptop>
	 <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
	 <1235647682.4948.15.camel@laptop>
	 <145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 13:20:06 +0100
Message-Id: <1235650806.4948.71.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 21:06 +0900, KAMEZAWA Hiroyuki wrote:
> Hmm.. some routine like
> atomic64_read() can help this ? (But I don't want to use atomic_t here..)

Yeah, atomic64_t has been proposed numerous times, and x86 could
actually implement that using cmpxchg8b, just not sure about all the
other 32bit archs, and if we start using it in the scheduler, they'd
better have it implemented.

Furthermore, it would require all the ops to be atomic, which would
require them all to use cmpxchg8b and its a horridly expensive op to
use :-(

