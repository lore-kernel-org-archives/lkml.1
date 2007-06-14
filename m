Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXFNO2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXFNO2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbXFNO2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:28:18 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:33168 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751845AbXFNO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:28:18 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 10:28:17 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AWICgoANXR9Fee1LUwycS8EF+JJGQP37l5RB9h5Mfnkl7Epcbktl8Cbr/9fOslQLFxTl6x98XoqyV0R7SptkFsfKrnyshkDWz5BsHJpzM40k6SIqUkn5GvWAeqQoBL7ZyzVXHvZi60nJ5a8Ej3BszaKx1KufFE6m3d9nF9rx6XA=  ;
X-YMail-OSG: 5Y4LzCYVM1mBFxSmH3u5N.R4A9rIATg_ft4l3SJyBsFdWUwUeHHtHaI859HOYouLsj2cwNXL2Q--
From: David Brownell <david-b@pacbell.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -mm 6/7] PM: Remove power_state.event checks from suspend core code
Date: Thu, 14 Jun 2007 07:21:34 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <200706131716.57915.rjw@sisk.pl>
In-Reply-To: <200706131716.57915.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140721.35478.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The suspend routines should be called for every device during a system sleep
> transition, regardless of the device's state, so that drivers can regard these
> method calls as notifications that the system is about to go to sleep, rather
> than as directives to put their devices into the 'off' state.

Did you audit all the drivers to make sure this won't break things?
Like for example through inappropriate pci_save_state() calls?

I'd really expect this patch would break things...
