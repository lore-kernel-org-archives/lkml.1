Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbXJ2R2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbXJ2R2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXJ2R2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:28:36 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:56485 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752960AbXJ2R2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:28:35 -0400
Subject: Re: [PATCH] sysfs: add filter function to groups
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1193678844.3782.7.camel@lov.site>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
	 <1193677071.3383.56.camel@localhost.localdomain>
	 <1193678844.3782.7.camel@lov.site>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 12:28:33 -0500
Message-Id: <1193678914.3383.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 18:27 +0100, Kay Sievers wrote:
> On Mon, 2007-10-29 at 11:57 -0500, James Bottomley wrote:
> > On Mon, 2007-10-29 at 17:54 +0100, Kay Sievers wrote:
> > > On Mon, 2007-10-29 at 10:16 -0500, James Bottomley wrote:
> 
> > > >  struct attribute_group {
> > > >  	const char		*name;
> > > > +	int			(*filter_show)(struct kobject *, int);
> > > 
> > > Are you sure that you want to return an array index here, instead of the
> > > actual attribute? Like:
> > 
> > Actually, it returns a true/false value indicating whether the given
> > attribute should be displayed.
> 
> It isn't about the return value of the function, that's fine. You call
> back with the index number (int) of the array of attributes, instead of
> passing the attribute pointer (struct attribute *attr) back to ask the
> device for the attribute to create.

For bitmaps, the int is what we will want.  I can add both to the
prototype if that will make you happy? so people searching on struct
attribute and not relying on the array construction order can use the
code as well.

James


