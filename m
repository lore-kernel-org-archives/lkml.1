Return-Path: <linux-kernel-owner+w=401wt.eu-S936506AbYEUVA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936506AbYEUVA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYEUVAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:00:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246AbYEUVAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:00:12 -0400
Date: Wed, 21 May 2008 13:52:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: benh@kernel.crashing.org
Cc: linux-arch@vger.kernel.org, linux-m32r@ml.linux-m32r.org,
       takata@linux-m32r.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org, LukeBrowning@us.ibm.com
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
Message-Id: <20080521135230.69c04ab4.akpm@linux-foundation.org>
In-Reply-To: <1211399081.8297.234.camel@pasglop>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
	<20080413171953.bde5e9ac.akpm@linux-foundation.org>
	<1208133506.6958.82.camel@pasglop>
	<20080413191338.9776ebd0.akpm@linux-foundation.org>
	<1208491086.6958.381.camel@pasglop>
	<20080417211905.8ff769fa.akpm@linux-foundation.org>
	<1208501061.6958.394.camel@pasglop>
	<1211392585.8297.218.camel@pasglop>
	<20080521114147.59ca3551.akpm@linux-foundation.org>
	<1211399081.8297.234.camel@pasglop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 15:44:41 -0400
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> On Wed, 2008-05-21 at 11:41 -0700, Andrew Morton wrote:
> > 
> > yup, gcc bug.  Discussed recently on lkml, "Subject: Re: huge gcc
> > 4.1.{0,1} __weak problem".  I don't think anything ended up happening
> > about it though.
> 
> Hrm... do you think we should work around ? ie. move the stubs to a
> separate .c file ?
> 

istr that sticking an asm(""); in the weak function was a reliable
workaround.  If we are going to to that it should be via

/* comment goes here */
#define gcc_screws_up_weak_stuff() asm("")

but that approach didn't seem very popular.  It's a _bit_ fragile I
guess, but it's pretty easy to grep for missed workarounds.

