Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYGBQrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYGBQrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYGBQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:47:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbYGBQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:47:14 -0400
Date: Wed, 2 Jul 2008 09:47:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: Is sysfs the right place to get cache and CPU topology info?
Message-Id: <20080702094711.6a93ff77.akpm@linux-foundation.org>
In-Reply-To: <18539.27303.187681.716560@cargo.ozlabs.ibm.com>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
	<20080702003755.4daff613.akpm@linux-foundation.org>
	<18539.20039.516803.51920@cargo.ozlabs.ibm.com>
	<20080702030154.67a851d2.akpm@linux-foundation.org>
	<18539.27303.187681.716560@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 21:46:47 +1000 Paul Mackerras <paulus@samba.org> wrote:

> > If they're talking about using the existing ones then sure, those are
> > cast in stone as far as I'm concerned.
> > 
> > But they do need to be a _bit_ defensive.  If they see a file which has
> > multiple name:value fields (shouldn't happen) then don't fail if new
> > tuples turn up later on.  Don't expect them to always be in the same
> > order.  Don't fail if new files later turn up in a sysfs directory.  If
> > a file has (a stupid) format like /proc/self/stat then be prepared for
> > new columns to appear later on, etc.
> > 
> > But if basic and obvious steps like that are taken in the library, and
> > later kernel changes cause that library to break, we get to fix the
> > kernel to unbreak their library.
> 
> I assume they can rely on finding the stuff they need under
> /sys/devices/system/cpu.  Or do they need to traverse the whole of
> /sys, and if so, how would they know which directories they should be
> looking in?

/sys/devices/system/cpu sounds good to me.  Everyone's mounting it at
/sys.
