Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYEMNLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYEMNLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYEMNLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:11:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYEMNLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:11:23 -0400
Date: Tue, 13 May 2008 09:11:01 -0400
From: Rik van Riel <riel@redhat.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 05/15] free swap space on swap-in/activation
Message-ID: <20080513091101.0448bbba@bree.surriel.com>
In-Reply-To: <482990FC.3020303@mxp.nes.nec.co.jp>
References: <20080428181835.502876582@redhat.com>
	<20080428181852.620969450@redhat.com>
	<4828283C.4000803@mxp.nes.nec.co.jp>
	<20080512093307.2ace3096@bree.surriel.com>
	<482990FC.3020303@mxp.nes.nec.co.jp>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 22:00:44 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On 2008/05/12 22:33 +0900, Rik van Riel wrote:
> > On Mon, 12 May 2008 20:21:32 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> >> So, the intention of this patch is
> >> not to free a swap space of swap cache that has already swapped in
> >> and only used one process as do_swap_page() does,
> >> but to free a swap space that is only used as a swap cache
> >> (not used by any processes), right?
> > 
> > No.  The code should also free the swap space of pages that are
> > mapped by processes, in order to free up swap space for other
> > uses.  This only happens if vm_swap_full() is true.
> > 
> 
> OK.
> 
> I thought that current code cannot free the swap space
> of pages that are mapped by processes(and I think it cannot),
> so I asked the intention of this patch for clarification.

You may be right, due to the refcounting magic that is going
on.  I will verify the code and send in a fix if it turns out
to be needed.

-- 
All rights reversed.
