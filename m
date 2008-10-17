Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYJQGSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYJQGSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYJQGSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:18:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36929 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYJQGSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:18:41 -0400
Date: Fri, 17 Oct 2008 08:25:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SYSFS: Fix return values for sysdev_store_{ulong,int}
Message-ID: <20081017062533.GZ12131@one.firstfloor.org>
References: <20081013100303.GA32199@basil.nowhere.org> <20081016133530.1024528d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016133530.1024528d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 01:35:30PM -0700, Andrew Morton wrote:
> On Mon, 13 Oct 2008 12:03:03 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > SYSFS: Fix return values for sysdev_store_{ulong,int}
> > 
> > Always return the full size instead of the consumed
> > length of the string in sysdev_store_{ulong,int}
> > 
> > This avoids EINVAL errors in some echo versions.
> 
> That sounds fairly serious.  Is this a regression or are those versions
> of echo really ancient, or...?

It's a regression, but it currently only affects the mce sysfs files,
which are the only ones using it. Also the EINVAL is more a cosmetic
issue because the first write will already change the value successfully,
only the second one will fail but not change anything.

-Andi

-- 
ak@linux.intel.com
