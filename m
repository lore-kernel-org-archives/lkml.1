Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXJaL4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXJaL4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXJaL4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:56:09 -0400
Received: from mail.softservecom.com ([195.160.232.17]:60565 "EHLO
	mail.softservecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbXJaL4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:56:07 -0400
Subject: Re: USB: FIx locks and urb->status in adutux
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, netwiz@crc.id.au
In-Reply-To: <20071030145421.f1f0aa53.zaitcev@redhat.com>
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	 <200710231138.38266.oliver@neukum.org>
	 <20071023185302.5ce9d187.zaitcev@redhat.com>
	 <1193234987.13750.21.camel@dell1.softservecom.com>
	 <20071024202555.4f1cd215.zaitcev@redhat.com>
	 <1193681097.20985.31.camel@dell1.softservecom.com>
	 <20071029212433.c9837c4b.zaitcev@redhat.com>
	 <1193749794.27085.15.camel@dell1.softservecom.com>
	 <20071030145421.f1f0aa53.zaitcev@redhat.com>
Content-Type: text/plain
Message-Id: <1193831694.2226.35.camel@dell1.softservecom.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-1) 
Date: Wed, 31 Oct 2007 13:54:54 +0200
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2007 11:54:54.0182 (UTC) FILETIME=[D9C70060:01C81BB4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 23:54, Pete Zaitcev wrote:

> One other small thing. I see you dropped the dev->mtx bracket that
> I added around the initialization and submission. Notice that the
> dev->udev is zeroed under dev->mtx, not the static lock. This is because
> it has to be seen in read and write paths. If you don't like taking
> across the submission, how about testing for it ahead of time?

I thought it can be managed under static lock.
But if you sure we can leave device lock too, I'm not familiar with all this on such deep level... at least for now;).

I'm not sure what kind of testing do you mean by "ahead of time". I just tried the latest patch and all seems to be good.

BTW, slab corruption issue that I saw on the original driver we started fixing on is not an issue any more.

Vitaliy

