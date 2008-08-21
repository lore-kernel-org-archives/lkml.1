Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYHUDmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYHUDmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbYHUDmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:42:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37627 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbYHUDmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:42:23 -0400
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Airlie <airlied@gmail.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Ingo Molnar <mingo@elte.hu>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
From: Andi Kleen <andi@firstfloor.org>
References: <48AA9C3B.5030309@keyaccess.nl> <20080819102633.GE6722@elte.hu>
	<48AAD680.7020508@keyaccess.nl>
	<20080819190757.GA17470@linux-os.sc.intel.com>
	<20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl>
	<48AC29CA.1060203@keyaccess.nl>
	<20080820194127.GA10887@linux-os.sc.intel.com>
	<48AC8F69.4050201@keyaccess.nl>
	<21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com>
	<20080820221630.GA3598@linux-os.sc.intel.com>
Date: Thu, 21 Aug 2008 05:42:18 +0200
In-Reply-To: <20080820221630.GA3598@linux-os.sc.intel.com> (Venki Pallipadi's message of "Wed, 20 Aug 2008 15:16:30 -0700")
Message-ID: <87wsibxcdh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi <venkatesh.pallipadi@intel.com> writes:
>
> We are also looking at changing the reserve_memtype in PAT, not to use linked
> list for RAM backed pages and track them in page struct.

Back when I hacked on this I explicitely chose to not do this because
it would make it impossible to put any normal anonymous pages into
the PAT list. While that's not done today there's no reason it couldn't
be done in the future.

Also it doesn't fix the scalability of the data structure anyways
(a list is a list),  just saves some memory.

-Andi
