Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbYDBRvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbYDBRvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYDBRvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:51:08 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51964
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbYDBRvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:51:07 -0400
Date: Wed, 2 Apr 2008 19:50:58 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 5/9] Convert anon_vma lock to rw_sem and refcount
Message-ID: <20080402175058.GR19189@duo.random>
References: <20080401205531.986291575@sgi.com> <20080401205636.777127252@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401205636.777127252@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 01:55:36PM -0700, Christoph Lameter wrote:
>   This results in f.e. the Aim9 brk performance test to got down by 10-15%.

I guess it's more likely because of overscheduling for small crtitical
sections, did you counted the total number of context switches? I
guess there will be a lot more with your patch applied. That
regression is a showstopper and it is the reason why I've suggested
before to add a CONFIG_XPMEM or CONFIG_MMU_NOTIFIER_SLEEP config
option to make the VM locks sleep capable only when XPMEM=y
(PREEMPT_RT will enable it too). Thanks for doing the benchmark work!
