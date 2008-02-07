Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYBGHLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYBGHLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYBGHLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:11:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54094
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbYBGHLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:11:14 -0500
Date: Wed, 06 Feb 2008 23:11:44 -0800 (PST)
Message-Id: <20080206.231144.174648341.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080207070044.GA4851@suse.de>
References: <20080207064210.GA22896@suse.de>
	<20080206.223944.200455039.davem@davemloft.net>
	<20080207070044.GA4851@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Wed, 6 Feb 2008 23:00:44 -0800

> On Wed, Feb 06, 2008 at 10:39:44PM -0800, David Miller wrote:
> > From: Greg KH <gregkh@suse.de>
> > Date: Wed, 6 Feb 2008 22:42:10 -0800
> > 
> > > On Wed, Feb 06, 2008 at 10:05:44PM -0800, David Miller wrote:
> > > > I found the problem, it's the "whole_disk" partition attribute.
> > > 
> > > I don't understand that code at all, on 2.6.24, what does reading that
> > > file give you?  At first glance, I don't see how that file would spit
> > > out anything and not give you the same kind of oops.
> > > 
> > > you are in a maze of kobject pointers, all alike...
> > 
> > It's supposed to just exist, and be an empty zero length file.
> > That's why it's given no ->show method pointer.
> > 
> > It's existence just means that the partition is a "whole disk"
> > partition type.
> 
> Can you try this patch to see if it solves the oops, and that the file
> is still there and works properly?

It doesn't crash, but the file returns -EIO instead of zero when read.

