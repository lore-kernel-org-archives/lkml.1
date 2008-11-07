Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYKGKbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYKGKbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 05:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYKGKbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 05:31:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYKGKbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 05:31:37 -0500
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Rik van Riel <riel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <20081107004131.GD2373@disturbed>
References: <20081106153022.215696930@redhat.com>
	 <1225986593.7803.4688.camel@twins> <20081106160154.GA7461@redhat.com>
	 <1225988173.7803.4723.camel@twins> <20081106163957.GB7461@redhat.com>
	 <1225990327.7803.4776.camel@twins> <491321ED.5010103@redhat.com>
	 <1225991487.7803.4801.camel@twins>  <20081107004131.GD2373@disturbed>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Nov 2008 11:31:44 +0100
Message-Id: <1226053904.7803.5856.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 11:41 +1100, Dave Chinner wrote:
> On Thu, Nov 06, 2008 at 06:11:27PM +0100, Peter Zijlstra wrote:
> > On Thu, 2008-11-06 at 11:57 -0500, Rik van Riel wrote:
> > > Peter Zijlstra wrote:
> > > 
> > > > The only real issue I can see is with linear volumes, but those are
> > > > stupid anyway - non of the gains but all the risks.
> > > 
> > > Linear volumes may well be the most common ones.
> > > 
> > > People start out with the filesystems at a certain size,
> > > increasing onto a second (new) disk later, when more space
> > > is required.
> > 
> > Are they aware of how risky linear volumes are? I would discourage
> > anyone from using them.
> 
> In what way are they risky?

You loose all your data when one disk dies, so your mtbf decreases with
the number of disks in your linear span.

And you get non of the benefits from having multiple disks, like extra
speed from striping, or redundancy from raid.

Therefore I say that linear volumes are the absolute worst choice.
