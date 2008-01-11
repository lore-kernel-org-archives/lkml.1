Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbYAKDEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbYAKDEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYAKDE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:04:26 -0500
Received: from smtp.knology.net ([24.214.63.101]:39788 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYAKDEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:04:25 -0500
Subject: Re: CONFIG_NO_HZ breaks blktrace timestamps
From: David Dillow <dillowda@ornl.gov>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <20080110234438.4826f658@inria.fr>
References: <1199918912.8388.13.camel@lap75545.ornl.gov>
	 <1199996752.9159.46.camel@lap75545.ornl.gov>
	 <20080110234438.4826f658@inria.fr>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 22:04:21 -0500
Message-Id: <1200020661.5099.3.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 23:44 +0100, Guillaume Chazarain wrote:
> David Dillow <dillowda@ornl.gov> wrote:
> 
> > At the moment, I'm not sure how to track this farther, or how to fix it
> > properly. Any advice would be appreciated.
> 
> Just out of curiosity, could you try the appended cumulative patch and
> report .clock_warps, .clock_overflows and .clock_underflows as you did.

With those patches, CONFIG_NO_HZ works just fine.

Patched kernel, nohz=off:
now at 214257.820809 msecs
  .clock                         : 214212.727559
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 244569.402345
  .clock_warps                   : 0
  .clock_overflows               : 577
  .clock_underflows              : 213887
  .clock_deep_idle_events        : 4
  .clock_max_delta               : 0.999830

Patched kernel, nohz=on:
now at 248931.524381 msecs
  .clock                         : 248745.808465
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 270911.098507
  .clock_warps                   : 0
  .clock_overflows               : 69
  .clock_underflows              : 784
  .clock_deep_idle_events        : 4
  .clock_max_delta               : 100.639397

Running my disk test, blktrace is getting the proper timestamps now with
CONFIG_NO_HZ.

Thanks!
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

