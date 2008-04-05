Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYDEA6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYDEA6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 20:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYDEA6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 20:58:04 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:38549
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYDEA6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 20:58:03 -0400
Date: Sat, 5 Apr 2008 02:57:59 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/10] emm: notifier logic
Message-ID: <20080405005759.GH14784@duo.random>
References: <20080404223048.374852899@sgi.com> <20080404223131.469710551@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404223131.469710551@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 03:30:50PM -0700, Christoph Lameter wrote:
> +	mm_lock(mm);
> +	e->next = mm->emm_notifier;
> +	/*
> +	 * The update to emm_notifier (e->next) must be visible
> +	 * before the pointer becomes visible.
> +	 * rcu_assign_pointer() does exactly what we need.
> +	 */
> +	rcu_assign_pointer(mm->emm_notifier, e);
> +	mm_unlock(mm);

My mm_lock solution makes all rcu serialization an unnecessary
overhead so you should remove it like I already did in #v11. If it
wasn't the case, then mm_lock wouldn't be a definitive fix for the
race.

> +		e = rcu_dereference(e->next);

Same here.
