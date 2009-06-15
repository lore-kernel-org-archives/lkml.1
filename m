Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbZFONHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbZFONHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZFONH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:07:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53767 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZFONHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:07:25 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <Pine.LNX.4.64.0906151329310.24256@sister.anvils>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <1245059859.23207.16.camel@penberg-laptop>
	 <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop>
	 <20090615112355.GB6012@wotan.suse.de>
	 <Pine.LNX.4.64.0906151329310.24256@sister.anvils>
Date: Mon, 15 Jun 2009 16:07:25 +0300
Message-Id: <1245071245.23207.45.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Mon, 2009-06-15 at 13:38 +0100, Hugh Dickins wrote:
> Fair enough that you jealously defend SL?B code from onslaught, but
> FWIW I strongly agree with Ben on all this.  I cannot see the point
> of the pain of moving around SL?B versus bootmem, if we immediately
> force such a distinction (differently dressed) upon their users again.

I'm fine with the current approach but I don't think this is completely
accurate. Passing a GFP flag from top to bottom (like we do in existing
code) is pretty natural compared to passing a "boot" boolean or using
system_state checks to switch between kmalloc() and bootmem_alloc().

So even with a GFP_BOOT flag, I do see advantages in being able to use
kmalloc() et al almost universally.

			Pekka

