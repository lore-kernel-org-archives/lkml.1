Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZKWOkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZKWOkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZKWOkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:40:32 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:57896 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZKWOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:40:32 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 09:40:32 EST
Date: Mon, 23 Nov 2009 08:31:40 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic
In-Reply-To: <1258966270.29789.45.camel@localhost>
Message-ID: <alpine.DEB.2.00.0911230830300.26432@router.home>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>  <1258440521.11321.32.camel@localhost> <1258443101.11321.33.camel@localhost>  <1258450465.11321.36.camel@localhost>  <alpine.DEB.1.10.0911171223460.20360@V090114053VZO-1>
 <1258966270.29789.45.camel@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Zhang, Yanmin wrote:

> Another theoretic issue is below scenario:
> Process A get the read lock on cpu 0 and is scheduled to cpu 2 to unlock. Then
> it's scheduled back to cpu 0 to repeat the step. eventually, the reader counter
> will overflow. Considering multiple thread cases, it might be faster to
> overflow than what we imagine. When it overflows, processes will hang there.

True.... We need to find some alternative to per cpu data to scale mmap
sem then.
