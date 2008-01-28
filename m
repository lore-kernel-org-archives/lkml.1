Return-Path: <linux-kernel-owner+w=401wt.eu-S1761902AbYA1TJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902AbYA1TJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYA1TJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:09:11 -0500
Received: from relay2.sgi.com ([192.48.171.30]:43842 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755238AbYA1TJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:09:09 -0500
Date: Mon, 28 Jan 2008 11:09:09 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Shaohua Li <shaohua.li@intel.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] some page can't be migrated
In-Reply-To: <20080126220351.a04819f9.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0801281107200.14323@schroedinger.engr.sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
 <1201233590.28282.13.camel@sli10-desk.sh.intel.com>
 <Pine.LNX.4.64.0801242000320.1932@schroedinger.engr.sgi.com>
 <200801251517.02287.nickpiggin@yahoo.com.au> <1201241005.24290.5.camel@sli10-desk.sh.intel.com>
 <20080126220351.a04819f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008, Andrew Morton wrote:

> We call something(GFP_KERNEL) under rcu_read_lock()?  I've lost track of
> the myriad flavours of rcu which we purport to support, but I don't think
> they'll all like us blocking under rcu_read_lock().
> 
> We _won't_ block, because try_to_release_page() will see the NULL ->mapping
> and will call the non-blocking try_to_free_buffers().  But still, it looks
> bad, and will cause problems if someone decides to add a might_sleep_if()
> to try_to_release_page().
> 
> So...  I'd suggest that it would be better to add an apologetic comment and
> call direct into try_to_free_buffers().

Right. Looks good. PageWriteback cannot be set if we do not have a 
mappig...

