Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYGIU54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYGIU54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYGIU4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:56:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47777 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbYGIU4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:56:36 -0400
Date: Wed, 9 Jul 2008 21:56:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       dbaryshkov@gmail.com
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper platform_device
Message-ID: <20080709205625.GE26734@flint.arm.linux.org.uk>
References: <20080709104916.200210922@fluff.org> <20080709104933.101610936@fluff.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709104933.101610936@fluff.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 11:49:20AM +0100, Ben Dooks wrote:
> This patch changes the mfd core behaviour to wrapper the platform_device
> it creates in an struct mfd_device which contains the information
> about the cell that was created.

You can't do this.  Grab a reference to the platform device (by holding
one of its sysfs files open) and then remove all the users of the mfd-core
module and the mfd-core module itself.

Then, read from that file and close it.  Watch your kernel oops.

That's why device release methods inside modules are a BAD IDEA and why
we have the platform device alloc API.
