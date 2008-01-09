Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbYAIN1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbYAIN1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYAIN0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:26:44 -0500
Received: from twin.jikos.cz ([213.151.79.26]:51121 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYAIN0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:26:41 -0500
Date: Wed, 9 Jan 2008 14:26:26 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Matthew Wilcox <matthew@wil.cx>
cc: Nikanth Karthikesan <knikanth@suse.de>, grant@torque.net, tim@cyberelk.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
 ioctl
In-Reply-To: <20080109123311.GP16309@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0801091425100.25041@twin.jikos.cz>
References: <4785B7BC.5040106@suse.de> <4785C7D8.2020808@suse.de>
 <20080109123311.GP16309@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008, Matthew Wilcox wrote:

> >  	default:
> >  		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
> > +		unlock_kernel();
> >  		return -EINVAL;
> Surely a bug ... shouldn't this return -ENOTTY?

What POSIX states [1]:

[EINVAL]
    The request or arg argument is not valid for this device.

[ENOTTY]
    The fildes argument is not associated with a STREAMS device that
    accepts control functions.

[1] http://www.opengroup.org/onlinepubs/009695399/functions/ioctl.html

-- 
Jiri Kosina
