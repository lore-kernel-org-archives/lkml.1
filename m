Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbXCYTYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbXCYTYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXCYTYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:24:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47031 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXCYTYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:24:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim <maximlevitsky@gmail.com>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Sun, 25 Mar 2007 21:27:30 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
References: <200703211840.53242.maximlevitsky@gmail.com> <200703251413.07799.rjw@sisk.pl> <200703251710.12842.maximlevitsky@gmail.com>
In-Reply-To: <200703251710.12842.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703252127.30895.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 March 2007 17:10, Maxim wrote:
> On Sunday 25 March 2007 14:13:07 Rafael J. Wysocki wrote:
> > On Sunday, 25 March 2007 01:40, Maxim wrote:
> > > On Friday 23 March 2007 16:42:44 Rafael J. Wysocki wrote:
> > > > On Friday, 23 March 2007 00:30, Rafael J. Wysocki wrote:
> > > > > On Thursday, 22 March 2007 00:53, Rafael J. Wysocki wrote:
> > > > > > On Thursday, 22 March 2007 00:39, Maxim wrote:
> > > > > > > On Thursday 22 March 2007 01:24:25 Rafael J. Wysocki wrote:
> > > > > > > > On Thursday, 22 March 2007 00:09, Maxim wrote:
> > > > > > > > > On Thursday 22 March 2007 00:39:02 you wrote:
> > > > > > > > > > On Wednesday, 21 March 2007 23:21, Pavel Machek wrote: 
> > > Hi,
> > > 	I confirm that the above patch works,
> > > 
> > > 	At least system didn't hang on resume with microcode driver loaded,
> > > 
> > > 	I can't really test whenever it did update microcode because I almost sure there is nothing to update
> > > 	(I use core 2 duo that I bought a month ago, and an intel motherboard with latest bios ( updated yesterday) )
> > > 	I selected this driver just in case when I compiled kernel.
> > 
> > OK, thanks for testing.
> > 
> 
> 
> Hello,
> 	I tested this patch, and it does work too,
> 	System suspended /resumed correctly, no errors in kernel log

Thanks for the confirmation.

I wonder if someone who actually needs the microcode to be updated can test
it ...

> > -	first_cpu = first_cpu(cpu_present_map);
> > -	if (!cpu_online(first_cpu)) {
> > -		error = _cpu_up(first_cpu);
> > -		if (error) {
> > -			printk(KERN_ERR "Could not bring CPU%d up.\n",
> > -				first_cpu);
> > -			goto out;
> > -		}
> > -	}
> > -
> 
> Nice, I once have seen those lines too, and they look ridiculous, but
> could that be that they are still necessary on some systems, 

I think this was a mistake from the beginning.

Rafael
