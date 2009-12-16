Return-Path: <linux-kernel-owner+w=401wt.eu-S935028AbZLPQ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028AbZLPQ2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935021AbZLPQ2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:28:14 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:60664 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935020AbZLPQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:28:12 -0500
Date: Wed, 16 Dec 2009 10:27:39 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
In-Reply-To: <20091216113158.GE15031@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.0912161025290.8572@router.home>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com> <20091216101107.GA15031@basil.fritz.box> <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com> <20091216102806.GC15031@basil.fritz.box> <20091216193109.778b881b.kamezawa.hiroyu@jp.fujitsu.com>
 <20091216104951.GD15031@basil.fritz.box> <20091216201218.42ff7f05.kamezawa.hiroyu@jp.fujitsu.com> <20091216113158.GE15031@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009, Andi Kleen wrote:

> > Do you have alternative recommendation rather than wrapping all accesses by
> > special functions ?
>
> Work out what changes need to be done for ranged mmap locks and do them all
> in one pass.

Locking ranges is already possible through the split ptlock and
could be enhanced through placing locks in the vma structures.

That does nothing solve the basic locking issues of mmap_sem. We need
Kame-sans abstraction layer. A vma based lock or a ptlock still needs to
ensure that the mm struct does not vanish while the lock is held.

