Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZI1QaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZI1QaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZI1QaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:30:12 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52971 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752639AbZI1QaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:30:11 -0400
Date: Mon, 28 Sep 2009 12:25:16 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Tony Vroon <tony@linx.net>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] percpu: fix unit_map[] verification in
 pcpu_setup_first_chunk()
In-Reply-To: <4AC0E201.2020006@kernel.org>
Message-ID: <alpine.DEB.1.10.0909281223510.16040@gentwo.org>
References: <4ABAC2F1.3020302@kernel.org> <1254055797.2756.1.camel@localhost> <4AC0E201.2020006@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Tejun Heo wrote:

> pcpu_setup_first_chunk() incorrectly used NR_CPUS as the impossible
> unit number while unit number can equal and go over NR_CPUS with
> sparse unit map.  This triggers BUG_ON() spuriously on machines which
> have non-power-of-two number of cpus.  Use UINT_MAX instead.

Uhhh. Funky. The assumption nr_cpu_ids < NR_CPUS has been broken. Wonder
what other effects that will have. In particular since the slab and page
allocators have arrays indexed by the cpu number and those arrays are
dimensioned for NR_CPUS.

