Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZI1Qpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZI1Qpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZI1Qpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:45:32 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:35378 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbZI1Qpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:45:31 -0400
Date: Mon, 28 Sep 2009 12:40:56 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Tony Vroon <tony@linx.net>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] percpu: fix unit_map[] verification in
 pcpu_setup_first_chunk()
In-Reply-To: <4AC0E6A3.4040500@kernel.org>
Message-ID: <alpine.DEB.1.10.0909281239100.16040@gentwo.org>
References: <4ABAC2F1.3020302@kernel.org> <1254055797.2756.1.camel@localhost> <4AC0E201.2020006@kernel.org> <alpine.DEB.1.10.0909281223510.16040@gentwo.org> <4AC0E5D8.6090707@kernel.org> <4AC0E6A3.4040500@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Tejun Heo wrote:

>
> Christoph, can you please elaborate why nr_cpu_ids < NR_CPUS is
> broken?

If its just an internal number that becomes larger than NR_CPUS then
everything is fine.

But if a real cpu id (returned by smp_processor_id()) gets larger than
NR_CPUS then we get into trouble with the parts of the kernel that index
by cpu id.

