Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYHIVv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYHIVv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYHIVvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:51:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46983 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbYHIVvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:51:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.27-rc2: unable to suspend - one task not freezed
Date: Sat, 9 Aug 2008 23:53:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <200808091018.32053.arvidjaar@mail.ru>
In-Reply-To: <200808091018.32053.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808092353.56006.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 9 of August 2008, Andrey Borzenkov wrote:
> 2.6.27-rc2 + unrevert of e872154921a6b5256a3c412dd69158ac0b135176
> (USB: don't explicitly reenable root-hub status interrupts) + fix
> of above from Alan Stern (OHCI: fix system hang caused by earlier patch).

Why do you have to unrevert commit e872154921a6b5256a3c412dd69158ac0b135176
exactly?

> System cannot be suspended - some task cannot be freezed. I think it is
> khubd ...

Yes, it is.

It looks like khubd is running in a loop without checking TIF_FREEZE.

> dmesg and config attached.

Hm.  Is this 100% reproducible?

Rafael
