Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYAGKez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYAGKez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYAGKeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:34:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36601 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYAGKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:34:35 -0500
Subject: Re: [PATCH] block2mtd lockdep_init_map warning
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20080107102025.GA5338@lazybastard.org>
References: <200801061911.m06JBldW020012@agora.fsl.cs.sunysb.edu>
	 <1199700326.7143.10.camel@twins>  <20080107102025.GA5338@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 07 Jan 2008 11:34:25 +0100
Message-Id: <1199702065.7143.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-07 at 11:20 +0100, Jörn Engel wrote:
> On Mon, 7 January 2008 11:05:26 +0100, Peter Zijlstra wrote:
> > 
> > Would something like this work for people?
> 
> Looks a lot better than what I thought of.  However, does the #ifdef
> within is_module_address() make sense when afaict lockdep is the only
> caller of that function?  Looks as if the whole function should be made
> conditional or none of it.

Ah, I hadn't bothered to check if there were more users. /me does a (not
so quick) git grep and finds lockdep is indeed the only caller. Sure, we
can move the whole function into the ifdef.


