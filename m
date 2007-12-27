Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbXL0X6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbXL0X6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 18:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXL0X6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 18:58:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbXL0X6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 18:58:07 -0500
Date: Thu, 27 Dec 2007 23:58:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Lameter <clameter@sgi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: SLUB sysfs support
Message-ID: <20071227235804.GJ27894@ZenIV.linux.org.uk>
References: <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com> <20071226221631.GD27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com> <20071227225947.GH27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712271552420.1154@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712271552420.1154@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 03:53:43PM -0800, Christoph Lameter wrote:
> On Thu, 27 Dec 2007, Christoph Lameter wrote:
> 
> > > a) remove symlink when slab goes away
> > 
> > Ok. Need to think about how to code that.
> 
> How do I iterate over all symlinks in /sys/kernel/slab/*?
> 
> I remember trying to do it before and not being able to find a sysfs 
> method for that.

What the hell do you need that for?  You have an obvious moment when
/sys/kernel/slab/cache_name -> <whatever> should be gone - it's when
you remove the slab called cache_name.  And at that point you don't
need to iterate over anything - you have the exact name, for fsck sake...

Why would you want these symlinks to stick around for longer than that?
