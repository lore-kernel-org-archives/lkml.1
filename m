Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbZDGVZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbZDGVZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757642AbZDGVZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:25:04 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:45286 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbZDGVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:25:03 -0400
Date: Tue, 7 Apr 2009 17:19:19 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Andi Kleen <andi@firstfloor.org>
cc: Lee.Schermerhorn@hp.com, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [10/16] POISON: Use bitmask/action code for try_to_unmap
 behaviour
In-Reply-To: <20090407151007.71F3F1D046F@basil.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0904071714450.12192@qirst.com>
References: <20090407509.382219156@firstfloor.org> <20090407151007.71F3F1D046F@basil.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Andi Kleen wrote:

> +
> +enum ttu_flags {
> +	TTU_UNMAP = 0,			/* unmap mode */
> +	TTU_MIGRATION = 1,		/* migration mode */
> +	TTU_MUNLOCK = 2,		/* munlock mode */
> +	TTU_ACTION_MASK = 0xff,
> +
> +	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */


Ignoring MLOCK? This means we are violating POSIX which says that an
MLOCKed page cannot be unmapped from a process? Note that page migration
does this under special pte entries so that the page will never appear to
be unmapped to user space.

How does that work for the poisoning case? We substitute a fresh page?

