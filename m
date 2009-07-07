Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbZGGP5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbZGGP5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZGGP5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:57:38 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42482 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754959AbZGGP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:57:37 -0400
Date: Tue, 7 Jul 2009 11:57:19 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch v2] slub: add option to disable higher order debugging
 slabs
In-Reply-To: <alpine.DEB.2.00.0907070013400.14978@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0907071150010.5124@gentwo.org>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <1246374095.8014.28.camel@penberg-laptop> <alpine.DEB.1.10.0906301114450.3879@gentwo.org> <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
 <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301722280.17682@gentwo.org> <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com> <84144f020906302253n2424d4a5k3aaf124838a041df@mail.gmail.com>
 <alpine.DEB.2.00.0907021016380.30890@chino.kir.corp.google.com> <84144f020907030023v2d09632bt13b6c25f96c0b803@mail.gmail.com> <alpine.DEB.2.00.0907062252500.9699@chino.kir.corp.google.com> <alpine.DEB.2.00.0907070013400.14978@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, David Rientjes wrote:

> + * Debugging flags that require metadata to be stored in the slab, up to
> + * DEBUG_SIZE in size.
> + */
> +#define DEBUG_SIZE_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
> +#define DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))

There is no need for DEBUG_SIZE since slub keeps both the size of the
object kmem_cache->objsize and the size with the metadata kmem_cache->size

If the order of both is different then the order would increase.

