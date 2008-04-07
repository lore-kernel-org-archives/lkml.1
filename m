Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYDGTgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYDGTgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYDGTfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:35:52 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:59010
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYDGTfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:35:52 -0400
Date: Mon, 7 Apr 2008 21:35:44 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 01/10] emm: mm_lock: Lock a process against reclaim
Message-ID: <20080407193544.GH20587@duo.random>
References: <20080404223048.374852899@sgi.com> <20080404223131.271668133@sgi.com> <47F6B5EA.6060106@goop.org> <20080405004127.GG14784@duo.random> <47FA6FDD.9060605@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FA6FDD.9060605@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 12:02:53PM -0700, Jeremy Fitzhardinge wrote:
> It's per-mm though.  How many processes would need to have notifiers?

There can be up to hundreds of VM in a single system. Not sure to
understand the point of the question though.

> Well, its definitely going to need more comments then.  I assumed it would 
> end up locking everything, so unlocking everything would be sufficient.

After your comments, I'm writing an alternate version that will
guarantee a O(N) worst case to both sigkill and cond_resched but
frankly this is low priority. Without mmu notifiers /dev/kvm can't be
given to a normal luser without at least losing mlock ulimits, so lack
of a mmu notifiers is a bigger issue than whatever complexity in
mm_lock as far as /dev/kvm ownership is concerned.
