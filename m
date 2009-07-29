Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZG2UTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZG2UTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZG2UTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:19:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46095 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbZG2UTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:19:12 -0400
Date: Wed, 29 Jul 2009 16:18:57 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern
Message-ID: <20090729201857.GC17410@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <1248880382.23840.78.camel@quest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248880382.23840.78.camel@quest>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 04:13:02PM +0100, Scott James Remnant wrote:
> On Mon, 2009-06-22 at 13:28 -0400, Neil Horman wrote:
> 
> > 2) Allow for the kernel to wait for a core_pattern process to complete.  One of
> > the things core_pattern processes might do is interrogate the status of a
> > crashing process via its /proc/pid directory.  To ensure that that directory is
> > not removed prematurely, we wait for the process to exit prior to cleaning it
> > up.
> > 
> Would this mean that the kernel would wait for the pattern process to
> complete before PANIC in the case of init core dumping?
> 
> I'd find that useful :-)
> 
Not without additional work.  If init crashed in the initramfs, I don't think
theres a way to handle that.  If it crashes at some later time, I think it just
gets restarted IIRC.  I'm sure you can change that behavior, but this patch
doesn't address that.

If you want to debug a custom init process, why not run a wrapper program as
init, that just forks the init you want to run and captures the core when it
crashes?
Neil

> Scott
> -- 
> Scott James Remnant
> scott@canonical.com


