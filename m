Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbZA0Eeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbZA0Eeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 23:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZA0Ee3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 23:34:29 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34449 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZA0Ee2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 23:34:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v2][PATCH]page_fault retry with NOPAGE_RETRY
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Ying Han <yinghan@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mikew@google.com, rientjes@google.com,
       rohitseth@google.com, hugh@veritas.com, a.p.zijlstra@chello.nl,
       hpa@zytor.com, edwintorok@gmail.com, lee.schermerhorn@hp.com,
       npiggin@suse.de
In-Reply-To: <20090126235715.GB8726@elte.hu>
References: <20090126155246.2d7df309.akpm@linux-foundation.org> <20090126235715.GB8726@elte.hu>
Message-Id: <20090128131715.D45E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 27 Jan 2009 13:34:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I think that a good way to present this is as a preparatory patch: 
> > "convert the fourth argument to handle_mm_fault() from a boolean to a 
> > flags word".  That would be a simple do-nothing patch which affects all 
> > architectures and which ideally would break the build at any unconverted 
> > code sites.  (Change the argument order?)
> 
> why not do what i suggested: refactor do_page_fault() into a platform 
> specific / kernel-internal faults and into a generic-user-pte function. 
> That alone would increase readability i suspect.
> 
> Then the 'retry' is multiple calls from handle_pte_fault().
> 
> Or something like that.
> 
> It looks wrong to me to pass another flag through this hot codepath, just 
> to express a property that the _highlevel_ code is interested in.

I like this idea :)



