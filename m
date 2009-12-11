Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbZLKENy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbZLKENy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbZLKENy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:13:54 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:30730 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755900AbZLKENx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:13:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PyzUTF+TTIiKG7MdJKVKCK3R4LihKPJwtE8ctKIkawCZgXdvxgdWaDC+feJg4IJWfcDoEDVoCoCZ0B3uJIsGZzdEUmSo4gFf51hAq1q/poRUFM01L3SjKPZiiPf39PbzVvLBQaUsAg1bcuyqCrvFxrsVLqkWJXnXU38OvRprsh0=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: M2x3DboVM1lhWb69WMICIU6nfkO8Ht_saQj6I6XBDfDmF8VTUZlvIx7MPaaRj4XNzXcIcUP.Vlia2hty0kjNcKufclvdzVXM5lYMQgktMq8P0xPWWLXdkQcH8pCmRdKbpd6zHsGV7x4WYJqBjuV3MjSKSrQFxL6AI1eqXVm5il5GMYQRN5Qrsso5_cUVaoqH8TJzLa6SabT.UXEEEWL5miGJCcow.zLSbPSoinP9WhMNuIHf0jU3bbRPQFY8Q_Lp
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use gpioN for device names
Date: Thu, 10 Dec 2009 20:13:58 -0800
User-Agent: KMail/1.9.10
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, dsilvers@simtec.co.uk, ben@simtec.co.uk,
       Artem.Bityutskiy@nokia.com, akpm@linux-foundation.org
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de>
In-Reply-To: <20091211034711.GA2773@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200912102013.59329.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 December 2009, Greg KH wrote:
> 
> > IMO a "good" solution in this space needs to accept that
> > those names are not going to be globally unique ... but
> > that they'll be unique within some context, of necessity.
> > 
> > If Greg doesn't want to see those names under classes,
> > so be it ... but where should they then appear?
> 
> As a sysfs file within the device directory called 'name'?  Then just
> grep through the tree to find the right device, that also handles
> duplicates just fine, right?

I want a concrete example.  Those chip->names things don't
seem helpful to me though...

If for example I were building a JTAG adapter on Linux, it
might consist of a spidev node (chardev) plus a handful of
GPIOs.  So "the device directory" would be the sysfs home
of that spidev node (or some variant)?  And inside that
directory would be files named after various signals that
are used as GPIOs ... maybe SRST, TRST, and DETECT to start
with?  Holding some cookie that gets mapped to those GPIO's
sysfs entries?

I confess I'd still think a symlink from that directory
to the real GPIO would be easier to work with...

- Dave

