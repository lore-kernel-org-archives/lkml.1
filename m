Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbYKFQQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbYKFQQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYKFQQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:16:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:41368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbYKFQQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:16:20 -0500
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <20081106160154.GA7461@redhat.com>
References: <20081106153022.215696930@redhat.com>
	 <1225986593.7803.4688.camel@twins>  <20081106160154.GA7461@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Nov 2008 17:16:13 +0100
Message-Id: <1225988173.7803.4723.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 11:01 -0500, Vivek Goyal wrote:

> > Does this still require I use dm, or does it also work on regular block
> > devices? Patch 4/4 isn't quite clear on this.
> 
> No. You don't have to use dm. It will simply work on regular devices. We
> shall have to put few lines of code for it to work on devices which don't
> make use of standard __make_request() function and provide their own
> make_request function. 
> 
> Hence for example, I have put that few lines of code so that it can work
> with dm device. I shall have to do something similar for md too.
> 
> Though, I am not very sure why do I need to do IO control on higher level
> devices. Will it be sufficient if we just control only bottom most
> physical block devices?
> 
> Anyway, this approach should work at any level.

Nice, although I would think only doing the higher level devices makes
more sense than only doing the leafs.

Is there any reason we cannot merge this with the regular io-scheduler
interface? afaik the only problem with doing group scheduling in the
io-schedulers is the stacked devices issue.

Could we make the io-schedulers aware of this hierarchy?
