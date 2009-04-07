Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbZDGWKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbZDGWKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZDGWKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:10:25 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:55285 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZDGWKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:10:24 -0400
Date: Tue, 7 Apr 2009 18:04:39 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Andi Kleen <andi@firstfloor.org>
cc: Lee.Schermerhorn@hp.com, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [10/16] POISON: Use bitmask/action code for try_to_unmap
 behaviour
In-Reply-To: <20090407215953.GA17934@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0904071802290.12192@qirst.com>
References: <20090407509.382219156@firstfloor.org> <20090407151007.71F3F1D046F@basil.firstfloor.org> <alpine.DEB.1.10.0904071714450.12192@qirst.com> <20090407215953.GA17934@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Andi Kleen wrote:

> > Ignoring MLOCK? This means we are violating POSIX which says that an
> > MLOCKed page cannot be unmapped from a process?
>
> I'm sure if you can find sufficiently vague language in the document
> to standards lawyer around that requirement @)
>
> The alternative would be to panic.


If you unmmap a MLOCKed page then you may get memory corruption because
f.e. the Infiniband layer is doing DMA to that page.

> > How does that work for the poisoning case? We substitute a fresh page?
>
> It depends on the state of the page. If it was a clean disk mapped
> page yes (it's just invalidated and can be reloaded). If it's a dirty anon
> page the process is normally killed first (with advisory mode on) or only
> killed when it hits the corrupted page. The process can also
> catch the signal if it choses so. The late killing works with
> a special entry similar to the migration case, but that results
> in a special SIGBUS.

I think a process needs to be killed if any MLOCKed page gets corrupted
because the OS cannot keep the POSIX guarantees.

