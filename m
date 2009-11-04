Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZKDNLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZKDNLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZKDNLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:11:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbZKDNLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:11:54 -0500
Date: Wed, 4 Nov 2009 15:08:28 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20091104130828.GC8920@redhat.com>
References: <cover.1257267892.git.mst@redhat.com> <20091103172422.GD5591@redhat.com> <878wema6o0.fsf@basil.nowhere.org> <20091104121009.GF8398@redhat.com> <20091104125957.GL31511@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104125957.GL31511@one.firstfloor.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 01:59:57PM +0100, Andi Kleen wrote:
> > Fine?
> 
> I cannot say -- are there paths that could drop the device beforehand?

Do you mean drop the mm reference?

> (as in do you hold a reference to it?)

By design I think I always have a reference to mm before I use it.

This works like this:
ioctl SET_OWNER - calls get_task_mm, I think this gets a reference to mm
ioctl SET_BACKEND - checks that SET_OWNER was run, starts virtqueue
ioctl RESET_OWNER - stops virtqueues, drops the reference to mm
file close - stops virtqueues, if we still have it then drops mm

This is why I think I can call use_mm/unuse_mm while virtqueue is running,
safely.
Makes sense?

> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.
