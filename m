Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbZEFPdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbZEFPdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbZEFPdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:33:05 -0400
Received: from kroah.org ([198.145.64.141]:37485 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbZEFPdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:33:01 -0400
Date: Wed, 6 May 2009 08:26:53 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] usb_debug: implement multi urb write
Message-ID: <20090506152653.GC4603@kroah.com>
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com> <1241575205-12199-2-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241575205-12199-2-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 09:00:01PM -0500, Jason Wessel wrote:
> The usb_debug driver, when used as the console, will always fail to
> insert the carriage return and new line sequence as well as randomly
> drop console output.  This is a result of only having the single
> write_urb and that the tty layer will have a lock that prevents the
> processing of the back to back urb requests.
> 
> The solution is to allow more than one urb to be outstanding and have
> a slightly deeper transmit queue.  The idea and some code is borrowed
> from the ftdi_sio usb driver.

Almost all usb-serial drivers need this functionality.

As you are adding it to the usb_debug driver, why not just add this kind
of functionality to the usb-serial core instead, that way we can share
it with all of the drivers?  I'd much rather see that happen instead of
us doing it individually again.

thanks,

greg k-h
