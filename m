Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZEMHzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZEMHzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 03:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZEMHyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 03:54:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53995 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZEMHyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 03:54:51 -0400
Date: Wed, 13 May 2009 10:00:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86: fix system without memory on node0
Message-ID: <20090513080010.GN19296@one.firstfloor.org>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com> <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com> <20090512150622.GA10015@sgi.com> <4A0A23A7.4080901@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A23A7.4080901@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
> +	/*
> +	 * make sure boot cpu node_number is right, when boot cpu is on the
> +	 * node that doesn't have mem installed
> +	 */
> +	per_cpu(node_number, boot_cpu_id) = cpu_to_node(boot_cpu_id);
> +#endif

Seems like a quite crappy hac^wpatch. Why is it ever set to the wrong
value? And why is that only the case on NUMA and 64bit? 

-Andi (who is also doubtful that the rest of the system can handle
memory less memory nodes in all cases)

-- 
ak@linux.intel.com -- Speaking for myself only.
