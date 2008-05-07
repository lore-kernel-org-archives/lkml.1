Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbYEGPcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbYEGPcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYEGPbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:31:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbYEGPbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:31:51 -0400
Date: Wed, 7 May 2008 08:31:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-Id: <20080507083105.b9874d78.akpm@linux-foundation.org>
In-Reply-To: <4821C370.1030801@firstfloor.org>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu>
	<1210126286.3453.37.camel@ymzhang>
	<1210131712.3453.43.camel@ymzhang>
	<87lk2mbcqp.fsf@basil.nowhere.org>
	<20080507114643.GR19219@parisc-linux.org>
	<87hcdab8zp.fsf@basil.nowhere.org>
	<alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
	<4821C370.1030801@firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 16:57:52 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> Or figure out what made the semaphore consolidation slower? As Ingo
> pointed out earlier 40% is unlikely to be a fast path problem, but some
> algorithmic problem. Surely that is fixable (even for .26)?

Absolutely.  Yanmin is apparently showing that each call to __down()
results in 1,451 calls to schedule().  wtf?

