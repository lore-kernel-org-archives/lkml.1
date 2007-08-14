Return-Path: <linux-kernel-owner+w=401wt.eu-S1760439AbXHNMyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439AbXHNMyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 08:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbXHNMy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 08:54:27 -0400
Received: from phunq.net ([64.81.85.152]:51569 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754075AbXHNMy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 08:54:26 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Block device throttling [Re: Distributed storage.]
Date: Tue, 14 Aug 2007 05:54:16 -0700
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708140532.31378.phillips@phunq.net> <20070814124656.GB10446@2ka.mipt.ru>
In-Reply-To: <20070814124656.GB10446@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708140554.18897.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2007 05:46, Evgeniy Polyakov wrote:
> > The throttling of the virtual device must begin in
> > generic_make_request and last to ->endio.  You release the throttle
> > of the virtual device at the point you remap the bio to an
> > underlying device, which you have convinced yourself is ok, but it
> > is not.  You seem to miss the fact that whatever resources the
> > virtual device has allocated are no longer protected by the
> > throttle count *of the virtual device*, or you do not
>
> Because it is charged to another device.

Great.  You charged the resource to another device, but you did not 
limit the amount of resources that the first device can consume.  Which 
misses the whole point.

Regards,

Daniel
