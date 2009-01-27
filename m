Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbZA0VsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbZA0VsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZA0Vrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:47:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50540
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754920AbZA0Vru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:47:50 -0500
Date: Tue, 27 Jan 2009 13:47:47 -0800 (PST)
Message-Id: <20090127.134747.153565246.davem@davemloft.net>
To: cl@linux-foundation.org
Cc: tj@kernel.org, rusty@rustcorp.com.au, mingo@elte.hu,
       herbert@gondor.apana.org.au, akpm@linux-foundation.org, hpa@zytor.com,
       brgerst@gmail.com, ebiederm@xmission.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, hugh@veritas.com,
       netdev@vger.kernel.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0901271506580.3114@qirst.com>
References: <200901271213.18605.rusty@rustcorp.com.au>
	<497E705B.5000302@kernel.org>
	<alpine.DEB.1.10.0901271506580.3114@qirst.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>
Date: Tue, 27 Jan 2009 15:08:57 -0500 (EST)

> On Tue, 27 Jan 2009, Tejun Heo wrote:
> 
> > > later). That's because they use TLB tricks for a static 64k per-cpu
> > > area, but this doesn't scale.  That might not be vital: abandoning
> > > that trick will mean they can't optimise read_percpu/read_percpu_var
> > > etc as much.
> 
> Why wont it scale? this is a separate TLB entry for each processor.

The IA64 per-cpu TLB entry only covers 64k which makes use of it for
dynamic per-cpu stuff out of the question.  That's why it "doesn't
scale"
