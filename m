Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYC1Leq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYC1Leq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYC1Lei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:34:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33431 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYC1Lei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:34:38 -0400
Date: Fri, 28 Mar 2008 12:38:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
Message-ID: <20080328113803.GQ29105@one.firstfloor.org>
References: <47ECD0CF.1020003@gmail.com> <87y783jdjo.fsf@basil.nowhere.org> <47ECD715.90507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ECD715.90507@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 12:31:33PM +0100, Jiri Slaby wrote:
> On 03/28/2008 12:25 PM, Andi Kleen wrote:
> >However the new standard way to do this is to not 
> >add new stuff into compat_ioctl.c, but define ->compat_ioctl
> >entry points in the low level drivers (and ideally converted
> >them to ->unlocked_ioctl too while you're at it)
> 
> Andi, the problem here is, that v4l has only open in fops which in turn 
> changes fops to the driver's one, so this would mean change all the drivers 
> in v4l...

And?  Are there that many? It's a simple mechanical operation.

> I second the converting to unlocked_ioctl and compat_ioctl in longer term 
> (for new drivers as a merging rule), but wouldn't be feasible to add them 
> to compat ioctl for now?

The problem with compat_ioctl is that it doesn't handle overlapping ioctl
ranges and that the compat code cannot be made modular (although if they
are compatible that is no big problem) 

BTW i haven't audited them, but if there is u64 or similar in there anywhere
be careful about alignment.

-Andi
