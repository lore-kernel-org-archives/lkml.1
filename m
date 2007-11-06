Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbXKFNeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbXKFNeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 08:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXKFNeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 08:34:13 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:36285 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXKFNeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:34:12 -0500
Subject: Re: [PATCH]bluetooth rfcomm_dev refcount bug fix
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <20071106060028.GA3176@darkstar.te-china.tietoenator.com>
References: <20071106060028.GA3176@darkstar.te-china.tietoenator.com>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 14:33:50 +0100
Message-Id: <1194356030.4763.18.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> I'm afraid to be considered as spam ;)
> 
> (Due to timezone offset, I have to mail again and cann't wait for your
> reply, sorry for the annoying)

I am in a different timezone every other week. So nevermind ;)

> I think the rfcomm_dev_put could be seperated from the rfcomm_dev_put,
> it will be more straitforward then.
> 
> please consider below patch, tested on my side. thanks.

That one looks totally wrong to me. Without even testing it, it will
have side effects that you haven't run into yet. Unless the TTY core
changed so much, this comments are there for a really good reason and
the code is tested a lot.

Also if you have to do two rfcomm_dev_put() in a row, then we are doing
something really wrong and this tries to hide a real bug somewhere.

Regards

Marcel


