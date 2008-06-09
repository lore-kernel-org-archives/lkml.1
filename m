Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYFITMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYFITMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYFITMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:12:18 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:3997 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbYFITMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:12:17 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
From: Andi Kleen <andi@firstfloor.org>
References: <20080530035620.587204923@sgi.com>
	<20080529215827.b659d032.akpm@linux-foundation.org>
	<4846AFCF.30500@sgi.com> <4848CC22.6090109@cosmosbay.com>
	<Pine.LNX.4.64.0806091136410.30727@schroedinger.engr.sgi.com>
Date: Mon, 09 Jun 2008 21:11:54 +0200
In-Reply-To: <Pine.LNX.4.64.0806091136410.30727@schroedinger.engr.sgi.com> (Christoph Lameter's message of "Mon, 9 Jun 2008 11:44:23 -0700 (PDT)")
Message-ID: <87abhuqv7p.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jun 2008 19:04:43.0568 (UTC) FILETIME=[AD278300:01C8CA63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> The problem is that offsets relative to %gs or %fs are limited by the 
> small memory model that is chosen.

Actually they are not. If you really want you can do 
movabs $64bit,%reg ; op ...,%gs:(%reg) 
It's just not very efficient compared to small (or rather kernel) model
and also older binutils didn't support large model.

-Andi
