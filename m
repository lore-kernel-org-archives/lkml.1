Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbYARHyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbYARHyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYARHyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:54:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:53792 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYARHyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:54:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rx23oghZ21ZsDFurdeRxoOn4Pz52IzeDRvuN8FJOs3OWZ/dH10E6DD5BkumwE9+wGFcKOjC9OEcTEAGFDpJm+aPLMe7jbIhSpvFB5zowPpUeOEo9EjXbv99PWgICWr6K712cMBoOmwKzYGhl27EKvdvbPAjuzigbq0Pus8wnft8=
Date: Fri, 18 Jan 2008 09:00:34 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080118080034.GB1703@ff.dom.local>
References: <20080117194728.GA2598@ami.dom.local> <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org> <20080117203155.GA2791@ami.dom.local> <20080117232626.GC2905@ami.dom.local> <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 09:42:25AM +0800, Dave Young wrote:
...
> After digging the class usage code again, I found that the only
> possible double lock place is the class_interface_register/unregister
> in which the class_device api could be called.

OK, but currently after using mostly:
mutex_lock(&parent_class)

and once:
mutex_lock_nested(&parent_class, SINGLE_DEPTH_NESTING)

lockdep mostly thinks these parent classes are 2 different objects,
with only 2 possible levels of nesting, so this parent_class has
to have wrong name (2 parents can't be locked from the same thread,
so maybe it's class_grandparent sometimes?).

Jarek P.
