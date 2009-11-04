Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZKDNhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZKDNhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZKDNhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:37:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47243 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbZKDNhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:37:24 -0500
Date: Wed, 4 Nov 2009 14:37:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20091104133728.GN31511@one.firstfloor.org>
References: <cover.1257267892.git.mst@redhat.com> <20091103172422.GD5591@redhat.com> <878wema6o0.fsf@basil.nowhere.org> <20091104121009.GF8398@redhat.com> <20091104125957.GL31511@one.firstfloor.org> <20091104130828.GC8920@redhat.com> <20091104131533.GM31511@one.firstfloor.org> <20091104131735.GD8920@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104131735.GD8920@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 03:17:36PM +0200, Michael S. Tsirkin wrote:
> On Wed, Nov 04, 2009 at 02:15:33PM +0100, Andi Kleen wrote:
> > On Wed, Nov 04, 2009 at 03:08:28PM +0200, Michael S. Tsirkin wrote:
> > > On Wed, Nov 04, 2009 at 01:59:57PM +0100, Andi Kleen wrote:
> > > > > Fine?
> > > > 
> > > > I cannot say -- are there paths that could drop the device beforehand?
> > > 
> > > Do you mean drop the mm reference?
> > 
> > No the reference to the device, which owns the mm for you.
> 
> The device is created when file is open and destroyed
> when file is closed. So I think the fs code handles the
> reference counting for me: it won't call file cleanup
> callback while some userspace process has the file open.
> Right?

Yes.

But the semantics when someone inherits such a fd through exec
or through file descriptor passing would be surely "interesting"
You would still do IO on the old VM.

I guess it would be a good way to confuse memory accounting schemes 
or administrators @)

It would be all saner if this was all a single atomic step.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
