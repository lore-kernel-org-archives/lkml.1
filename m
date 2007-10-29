Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbXJ2R6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbXJ2R6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXJ2R6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:58:43 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41062 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbXJ2R6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:58:42 -0400
Message-ID: <47261F50.3050901@s5r6.in-berlin.de>
Date: Mon, 29 Oct 2007 18:58:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
References: <1193671019.3383.13.camel@localhost.localdomain>	 <1193676852.2655.21.camel@lov.site> <1193677071.3383.56.camel@localhost.localdomain>
In-Reply-To: <1193677071.3383.56.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> >  struct attribute_group {
>> >  	const char		*name;
>> > +	int			(*filter_show)(struct kobject *, int);

> Actually, it returns a true/false value indicating whether the given
> attribute should be displayed.

How about this:

	int (*is_visible)(...);
or
	bool (*shall_be_shown)(...);
or
	bool (*should_be_displayed)(...);

or whatever, so that it indicates that this function merely answers a
question, but doesn't filter nor show anything.
-- 
Stefan Richter
-=====-=-=== =-=- ===-=
http://arcgraph.de/sr/
