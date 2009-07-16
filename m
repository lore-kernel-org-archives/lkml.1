Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZGPE1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZGPE1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZGPE1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:27:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054AbZGPE1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:27:23 -0400
Date: Wed, 15 Jul 2009 21:26:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] throttle direct reclaim when too many pages are
 isolated already (v3)
Message-Id: <20090715212657.aa85089a.akpm@linux-foundation.org>
In-Reply-To: <4A5EA7E1.7030403@redhat.com>
References: <20090715223854.7548740a@bree.surriel.com>
	<20090715194820.237a4d77.akpm@linux-foundation.org>
	<4A5E9A33.3030704@redhat.com>
	<20090715202114.789d36f7.akpm@linux-foundation.org>
	<4A5E9E4E.5000308@redhat.com>
	<20090715203854.336de2d5.akpm@linux-foundation.org>
	<20090715235318.6d2f5247@bree.surriel.com>
	<20090715210253.bc137b2d.akpm@linux-foundation.org>
	<4A5EA7E1.7030403@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 00:09:05 -0400 Rik van Riel <riel@redhat.com> wrote:

> > If we were to step back and approach this in a broader fashion, perhaps
> > we would find some commonality with the existing TIF_MEMDIE handling,
> > dunno.
> 
> Good point - what is it that makes TIF_MEMDIE special
> wrt. other fatal signals, anyway?
> 
> I wonder if we should not simply "help along" any task
> with fatal signals pending, anywhere in the VM (and maybe
> other places in the kernel, too).
> 
> The faster we get rid of a killed process, the sooner its
> resources become available to the other processes.

Spose so.

Are their any known (or makeable uppable) situations in which such a
change would be beneficial?  Maybe if the system is in a hopeless
swapstorm and someone is killing processes in an attempt to get control
back.

