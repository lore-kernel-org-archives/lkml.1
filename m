Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYELNdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYELNdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYELNdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:33:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYELNda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:33:30 -0400
Date: Mon, 12 May 2008 09:33:07 -0400
From: Rik van Riel <riel@redhat.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 05/15] free swap space on swap-in/activation
Message-ID: <20080512093307.2ace3096@bree.surriel.com>
In-Reply-To: <4828283C.4000803@mxp.nes.nec.co.jp>
References: <20080428181835.502876582@redhat.com>
	<20080428181852.620969450@redhat.com>
	<4828283C.4000803@mxp.nes.nec.co.jp>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 20:21:32 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> So, the intention of this patch is
> not to free a swap space of swap cache that has already swapped in
> and only used one process as do_swap_page() does,
> but to free a swap space that is only used as a swap cache
> (not used by any processes), right?

No.  The code should also free the swap space of pages that are
mapped by processes, in order to free up swap space for other
uses.  This only happens if vm_swap_full() is true.

-- 
All rights reversed.
