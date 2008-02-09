Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYBIB5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYBIB5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 20:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYBIB5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 20:57:06 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:56940
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYBIB5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 20:57:05 -0500
Date: Sat, 9 Feb 2008 02:56:59 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Roland Dreier <rdreier@cisco.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
       avi@qumranet.com, linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, Rik van Riel <riel@redhat.com>
Subject: Re: [ofa-general] Re: [patch 0/6] MMU Notifiers V6
Message-ID: <20080209015659.GC7051@v2.random>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com> <20080208234302.GH26564@sgi.com> <20080208155641.2258ad2c.akpm@linux-foundation.org> <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com> <adaprv70yyt.fsf@cisco.com> <Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com> <adalk5v0yi6.fsf@cisco.com> <Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com> <20080209012446.GB7051@v2.random> <Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 05:27:03PM -0800, Christoph Lameter wrote:
> Pages will still be on the LRU and cycle through rmap again and again. 
> If page migration is used on those pages then the code may make repeated 
> attempt to migrate the page thinking that the page count must at some 
> point drop.
>
> I do not think that the page count was intended to be used to pin pages 
> permanently. If we had a marker on such pages then we could take them off 
> the LRU and not try to migrate them.

The VM shouldn't break if try_to_unmap doesn't actually make the page
freeable for whatever reason. Permanent pins shouldn't happen anyway,
so defining an ad-hoc API for that doesn't sound too appealing. Not
sure if old hardware deserves those special lru-size-reduction
optimizations but it's not my call (certainly swapoff/mlock would get
higher priority in that lru-size-reduction area).
