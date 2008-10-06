Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbYJFFig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbYJFFig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYJFFi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:38:28 -0400
Received: from kroah.org ([198.145.64.141]:40704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752509AbYJFFi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:38:28 -0400
Date: Sun, 5 Oct 2008 22:36:58 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 38/76] tty: usb-serial krefs
Message-ID: <20081006053658.GA26817@kroah.com>
References: <20081005160231.1997.10462.stgit@localhost.localdomain> <20081005161056.1997.12765.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005161056.1997.12765.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 05:11:38PM +0100, Alan Cox wrote:
> Use kref in the USB serial drivers so that we don't free tty structures
> from under the URB receive handlers as has historically been the case if
> you were unlucky. This also gives us a framework for general tty drivers to
> use tty_port objects and refcount.

Should we be calling kref_get() and kref_put() in interrupt context?
Could we just get the reference in open and then put in close when we
are done with it for each driver?

thanks,

greg k-h
