Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYCDGWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYCDGWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbYCDGVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:21:52 -0500
Received: from smtp-out.google.com ([216.239.33.17]:3956 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYCDGVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:21:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=w7GNmSGThntilw+U+r+U6nYVqyvBTDCxKajfKHaHusBvYoiLuvX33J14Cmb95ZqL7
	tBH3YHDBXgGxI0DAcvEVQ==
Message-ID: <6599ad830803032221j740c9657yec237ebbadbeaeaa@mail.gmail.com>
Date: Mon, 3 Mar 2008 22:21:41 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080304001507.3ddc8f26.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080227222103.673194000@chello.nl>
	 <47C8771C.1070001@qualcomm.com> <1204545445.11412.6.camel@twins>
	 <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy>
	 <20080303121033.c8c9651c.pj@sgi.com>
	 <6599ad830803031041r6c635141n6520a915f2e1d08@mail.gmail.com>
	 <20080303125253.5d2d580c.pj@sgi.com>
	 <6599ad830803032126m39935eaeu1df67d6263e8e123@mail.gmail.com>
	 <20080304001507.3ddc8f26.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 10:15 PM, Paul Jackson <pj@sgi.com> wrote:
>  implementation, just with a less natural cpuset hierarchy (more leaf
>  node cpusets, representing the cross product of interesting CPU subsets
>  and interesting memory node subsets.)

Except that this isn't currently possible if you're also trying to do
memory hardwalling on those cpusets, since then sibling cpusets can't
share memory nodes.

Having said that, this bit of the problem can be fixed without
splitting cpus/mems, by my other earlier proposal of adding a separate
"mem_hardwall" flag that can enable the hardwall behaviour without the
exclusive behaviour. (i.e. hardwall behaviour occurs if mem_exclusive
|| mem_hardwall)

Paul
