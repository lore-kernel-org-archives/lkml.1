Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZKCXrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZKCXrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZKCXrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:47:36 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53296 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753071AbZKCXrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:47:33 -0500
Date: Tue, 3 Nov 2009 23:47:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       david-b@pacbell.net, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] gpiolib: fix device_create() result check
Message-ID: <20091103234747.59c0e2ca@lxorguk.ukuu.org.uk>
In-Reply-To: <20091103144401.6fa4e130.akpm@linux-foundation.org>
References: <200910202035.23981.sshtylyov@ru.mvista.com>
	<20091103144401.6fa4e130.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 14:44:01 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 20 Oct 2009 20:35:23 +0400
> Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> 
> > In case of failure, device_create() returns not NULL but the error code.
> > The current code checks for non-NULL though which causes kernel oops in
> > sysfs_create_group() when device_create() fails.  Check for error using
> > IS_ERR() and propagate the error value using PTR_ERR() instead of fixed
> > -ENODEV code returned now...
> 
> Does anyone notice any missing information here?

its what you get for cheap hacks instead of having a ptr_err_t which is a
union so you have to get it right ;)

Alan
