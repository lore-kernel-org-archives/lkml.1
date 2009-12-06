Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZLFVB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZLFVB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758007AbZLFVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:01:57 -0500
Received: from kroah.org ([198.145.64.141]:34475 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005AbZLFVB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:01:56 -0500
Date: Sun, 6 Dec 2009 12:52:27 -0800
From: Greg KH <greg@kroah.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: cbou@mai.ru, dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091206205227.GA21681@kroah.com>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 11:42:22AM +0100, Linus Walleij wrote:
> However we want to override the default table with one fed in
> though e.g. sysfs, so calibration data for the battery can reside
> in the file system. NOTE: this table is NOT of fixed length, i.e.
> we don't know how many (x,y) pairs will be passed in.
> 
> Whereas the rule for sysfs is one value per file, creating an arbitrary
> large hirarchy like this:
> 
> /sys/.../v_vs_cap/x0
> /sys/.../v_vs_cap/y0
> /sys/.../v_vs_cap/x1
> /sys/.../v_vs_cap/y2
> ...
> /sys/.../v_vs_cap/xN
> /sys/.../v_vs_cap/yN
> 
> Is probably not very elegant. (Or is it?) Would it be permissible to
> pass in a table like:
> 
> cat >/sys/.../v_vs_cap <<EOF
> x0,y0
> x1,y1
> x2,y2
> EOF
> 
> And have the kernel parse x,y pairs up to EOF?

No, please don't do this through sysfs, it is not set up to handle this
(hint, what happens if you put more than one PAGE_SIZE of data to the
file?)

Use configfs instead, that is what it is there for.

Or use userspace to handle the mapping table, that would be preferable
than to parse anything within the kernel.

thanks,

greg k-h
