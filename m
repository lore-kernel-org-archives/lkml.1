Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZF1Ljt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZF1Ljt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 07:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZF1Ljk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 07:39:40 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:53548 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZF1Ljk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 07:39:40 -0400
Date: Sun, 28 Jun 2009 15:39:40 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, max@stro.at,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH] alpha: fix percpu build breakage
Message-ID: <20090628113940.GA11836@jurassic.park.msu.ru>
References: <20090625090842.GA17936@stro.at> <20090625115423.6a31b49c.akpm@linux-foundation.org> <4A4419AA.2040400@kernel.org> <20090626124705.GA25147@jurassic.park.msu.ru> <20090626115746.09314757.akpm@linux-foundation.org> <20090626122152.e124254b.akpm@linux-foundation.org> <4A46BE34.7040806@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A46BE34.7040806@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 09:49:56AM +0900, Tejun Heo wrote:
> alpha percpu access requires custom SHIFT_PERCPU_PTR() definition for
> modules to work around addressing range limitation.  This is done via
> generating inline assembly using C preprocessing which forces the
> assembler to generate external reference.  This happens behind the
> compiler's back and makes the compiler think that static percpu
> variables in modules are unused.
> 
> This used to be worked around by using __unused attribute for percpu
> variables which prevent the compiler from omitting the variable;
> however, recent declare/definition attribute unification change broke
> this as __used can't be used for declaration.  Also, in the process,
> PER_CPU_ATTRIBUTES definition in alpha percpu.h got broken.
> 
> This patch adds PER_CPU_DEF_ATTRIBUTES which is only used for
> definitions and make alpha use it to add __used for percpu variables
> in modules.  This also fixes the PER_CPU_ATTRIBUTES double definition
> bug.

Thanks! I was going to suggest similar patch, but you've beaten
me to it ;-)

> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

As for upcoming percpu patchset, can we similarly move the __weak attribute
to PER_CPU_DEF_ATTRIBUTES? I don't feel really comfortable with an
"extern __weak" combination - it may not work with future compilers...

Ivan.
