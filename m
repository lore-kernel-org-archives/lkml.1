Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbXK0Kja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbXK0Kja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbXK0KjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:39:13 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:43817 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbXK0KjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:39:12 -0500
Subject: Re: [Bluez-devel] 2.6.23.8: kernel panic
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Marco Pracucci <development@pracucci.com>,
       bluez-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20071127103239.GA4477@darkstar.te-china.tietoenator.com>
References: <4746EC10.5080509@pracucci.com>
	 <20071127103239.GA4477@darkstar.te-china.tietoenator.com>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 11:38:24 +0100
Message-Id: <1196159904.17196.33.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> This problem is caused by the workqueue in hci_sysfs.c, the del_conn is scheduled after the add_conn with same bluetooth address.
> 
> Please try this patch:
> ----------------------------
> 
> The bluetooth hci conn sysfs add/del executed in the default workqueue. If the conn del function is executed after the new conn add function with same bluetooth target address, the connection add will failed and warning about same kobject name.
> 
> Here add a btconn workqueue, and flush the workqueue in the add_conn function to avoid the above issue. 

the patch looks good to me (except some style cleanups). Let me push it
to one of my test machines and stress it a little bit. I give you
feedback after my testing.

Regards

Marcel


