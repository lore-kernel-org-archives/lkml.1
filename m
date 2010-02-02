Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0BBNIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 08:08:53 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:53673 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0BBNIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:08:51 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 2 Feb 2010 14:08:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
References: <20100129185434.GH19501@one-eyed-alien.net> <201002021307.56991.oliver@neukum.org> <1265114375.12634.61.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1265114375.12634.61.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002021408.51851.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 2. Februar 2010 13:39:35 schrieb Catalin Marinas:
> > For storage that is correct. But what about other sources of pages,
> > for example iSCSI?
> 
> In the iSCSI case, does the HCD driver write directly to a page cache
> page? Or it just fills in network packets that are copied to page cache
> pages by the iSCSI code (sorry, I'm not familiar with this part of the
> kernel). If the latter, the cache flushing in the HCD driver would not
> help and it needs to be done in the iSCSI code.

As far as I can tell iSCSI does a private copy. But I don't know how
many methods to transfer code pages over USB exist. I'd say the
conservative solution is to flush for everything but control transfers.

	Regards
		Oliver
