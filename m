Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZFXCna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZFXCna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 22:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFXCnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 22:43:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54691 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZFXCnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 22:43:21 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/3] make mapped executable pages the first class citizen
Cc: kosaki.motohiro@jp.fujitsu.com, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <20090624023251.GA16483@localhost>
References: <7561.1245768237@redhat.com> <20090624023251.GA16483@localhost>
Message-Id: <20090624114055.225D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 24 Jun 2009 11:43:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jun 23, 2009 at 10:43:57PM +0800, David Howells wrote:
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > David, could you try running this when it occurred again?
> > > 
> > >         make Documentation/vm/page-types
> > >         Documentation/vm/page-types --raw  # run as root
> > 
> > Okay.  I managed to catch it between the first and second OOMs, and ran the
> > command you asked for.
> 
> Thank you!
> 
> > 0x0000000000000000	    142261      555  ________________________________	
> > 0x0000000000000400	      6797       26  __________B_____________________	buddy
> 
> The buddy+free numbers are pretty high. 26MB PG_buddy pages means much
> more actual free pages. So I bet the 555MB no-flag pages are mostly free pages.

You mean our VM can make OOM although it have 600MB free pages?



