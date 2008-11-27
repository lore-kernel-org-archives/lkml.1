Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYK0MdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYK0MdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYK0Mcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:32:52 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:51678 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYK0Mcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:32:51 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, Mike Waychison <mikew@google.com>,
       Ying Han <yinghan@google.com>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <492E90BC.1090208@gmail.com>
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com>
	 <20081123091843.GK30453@elte.hu>
	 <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com>
	 <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com>
	 <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com>
	 <492E8708.4060601@gmail.com> <20081127120330.GM28285@wotan.suse.de>
	 <492E90BC.1090208@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Nov 2008 13:32:36 +0100
Message-Id: <1227789156.4454.1519.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 14:21 +0200, Török Edwin wrote:

> How about distributing tasks to a set of worked threads, is the
> overhead of using IPC instead of mutexes/cond variables acceptable?

Inter process pthread mutexes should be very fast in the latest kernels
as they'll avoid the mmap_sem by use of get_user_pages_fast().

Not sure if pthread condition variables also work inter-process.

