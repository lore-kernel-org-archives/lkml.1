Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZFDRMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZFDRMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZFDRML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:12:11 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46355 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751867AbZFDRMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:12:10 -0400
Date: Thu, 4 Jun 2009 13:11:53 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Yinghai Lu <yinghai@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, mel@csn.ul.ie,
       suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, steiner@sgi.com,
       rientjes@google.com
Subject: Re: [RESEND PATCH] mm: clear N_HIGH_MEMORY map before se set it
 again -v2
In-Reply-To: <4A27FAD4.2010104@kernel.org>
Message-ID: <alpine.DEB.1.10.0906041309230.8080@gentwo.org>
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie> <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie> <4A0C4910.7090508@kernel.org> <4A0C4A2A.6080009@kernel.org> <20090514095414.ba8356e5.akpm@linux-foundation.org>
 <4A0C4F67.5080802@kernel.org> <20090514102554.b3a36f19.akpm@linux-foundation.org> <4A0C563A.3020100@kernel.org> <4A2758CB.9090404@kernel.org> <alpine.DEB.1.10.0906041236520.5377@gentwo.org> <4A27FAD4.2010104@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Yinghai Lu wrote:

> in case some system strange SRAT table. some kind of small range form some node
> or with mem= boot option etc. that node will not be onlined.
> In the early checking, the bit in node_states[N_HIGH_MEMORY] for the
> node is set even that node has less RAM like 1M.

Maybe we can replace that with:

SRAT tables may contains nodes of very small size. The arch code may
decide to not activate such a node. However, currently the early boot code
sets N_HIGH_MEMORY for such nodes. These nodes therefore seem to be active
although these nodes have no present pages.

