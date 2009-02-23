Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZBWUbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZBWUbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZBWUbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:31:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961AbZBWUbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:31:11 -0500
Date: Mon, 23 Feb 2009 12:30:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: nickpiggin@yahoo.com.au, vegard.nossum@gmail.com, mingo@elte.hu,
       stable@kernel.org, npiggin@suse.de, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-Id: <20090223123045.aa993f8f.akpm@linux-foundation.org>
In-Reply-To: <20090223201236.GS6751@linux.vnet.ibm.com>
References: <20090220140157.GA12799@elte.hu>
	<20090222030030.GD6860@linux.vnet.ibm.com>
	<20090223051709.GA5990@linux.vnet.ibm.com>
	<200902240029.37815.nickpiggin@yahoo.com.au>
	<20090223161726.GD6751@linux.vnet.ibm.com>
	<20090223111009.d48ff81d.akpm@linux-foundation.org>
	<20090223193057.GL6751@linux.vnet.ibm.com>
	<20090223115926.ed03e954.akpm@linux-foundation.org>
	<20090223201236.GS6751@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 12:12:36 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > As I suggested before, please add a new state variable which is private
> > to your subsystem.  That way it remains isolated from other subsystems.
> 
> OK, so my thought would be to have a function call into RCU from either
> init_post() or from rest_init().  This function would then set a variable
> private to RCU.
> 
> Seem reasonable?
> 

If that flag will only be used by one flavour of RCU then that would be
a good way to go.

Otherwise, heck, just make it a global variable with a well-chosen name
and write to it directly.  Simple, perfectly clear and understandable..

