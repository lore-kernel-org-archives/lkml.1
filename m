Return-Path: <linux-kernel-owner+w=401wt.eu-S1760465AbZJMQZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465AbZJMQZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760103AbZJMQZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:25:03 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47759 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZJMQY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:24:59 -0400
Date: Tue, 13 Oct 2009 11:25:11 -0500
From: scameron@beardog.cce.hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: Add cciss_allow_hpsa module parameter.
Message-ID: <20091013162511.GZ23265@beardog.cce.hp.com>
References: <20091012153606.4367.73416.stgit@beardog.cce.hp.com> <20091012150615.f9572d8a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012150615.f9572d8a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 03:06:15PM -0700, Andrew Morton wrote:
> On Mon, 12 Oct 2009 10:36:25 -0500
> "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:
> 
> > Add cciss_allow_hpsa module parameter.  This parameter causes
> > the cciss driver to ignore any Smart Array devices known to be
> > supported by the hpsa driver.
> 
> An alternative approach would be to ensure that hpsa is loaded first. 
> Then when cciss tries to control a device it will fail to acquire that
> devices's PCI regions and will bale out in an orderly manner.
> 
> I don't know how we can reliably arrange for hpsa to execute first, but
> I'm sure someone does ;)
> 
> Unless CONFIG_CCISS=y, CONFIG_HPSA=m.  Then we're screwed.

My thinking was that with the module parameter, the default behavior
of cciss would be (almost*) unchanged, which would mean that people putting a
new kernel on an existing system would not get surprised when say,
 /dev/cciss/c0d0, likely their boot device, suddenly showed up as
/dev/sda instead, and their system wouldn't boot, their (old) Array
Configuration Utility didn't know what to make of hpsa, etc.

If somebody wants to switch to hpsa then they can via the module parameter,
but I think it's not a good idea to force them to switch at this time with no
real notice other than sudden failure to boot due to broken grub entries, 
fstab entries, etc.

(*the change in the default behavior would be that cciss would no longer load
on controllers which it doesn't explicitly know about.)

-- steve

