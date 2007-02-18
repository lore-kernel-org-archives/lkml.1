Return-Path: <linux-kernel-owner+w=401wt.eu-S1161097AbXBRHzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161097AbXBRHzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 02:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161086AbXBRHzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 02:55:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:11699 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161097AbXBRHzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 02:55:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=r6KibbmG4i0EL7FMpku/wsFr8qqNY/gch0XVqPpOl724oJXsxuUju8UKQsII8RpN2ITC61KPXwc4gFFJpq5UOoI2olOFPsOyvRyjk1ZUS/MJyPbQ6afdH/Hz9ow0kQwWZ341ieRfIF4r+lQXNEn/gZu1aAwSUdMSKMtISUwBhiw=
Date: Sun, 18 Feb 2007 10:52:09 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Lew Glendenning <lglendenning@lnxi.com>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070218075209.GA10865@cvg>
References: <20070217212918.GA26554@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217212918.GA26554@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 11:29:19PM +0200, Dan Aloni wrote:
| Hello,
| 
| I'm running the x86_64 arch of Linux 2.6.20 on a Supermicro X6DH8-XG2 
| board and I got this during boot:
| 
| [248660.950695] device id = 2440
| [248660.950699] device id = 2480
| [248660.950703] device id = 24c0
| [248660.950706] device id = 24d0
| [248660.950709] matched device = 24d0
| [248660.950712] matched device id 24d0
| [248660.950716] pci_read_config_byte : 4
| [248660.950723] esb2rom: esb2rom_init_one(): Unable to register resource 
| 0xffffffffffc00000-0xffffffff - kernel bug?
| [248660.950729] esb2rom: ioremap(ffffffffffc00000, 100400000) failed
| [248660.956859] retVal = -19
| 
| Looks like some kind of a 64-bit portability bug...
| 
| -- 
| Dan Aloni
| XIV LTD, http://www.xivstorage.com
| da-x (at) monatomic.org, dan (at) xiv.co.il
| -
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
| 

Hi Dan,

I think that is not 64-bit portability bug and the code should be
reviewed by Lew Glendenning (who wrote it). I'm sending a copy of
the message to Lew and hope he'll check the code ;)

P.S. (for Lew)
	Lew, I think window->phys in esb2rom_init_one() remains in zero
	and then sets it to 0xffffffffffc00000 after 

		window->phys -= 0x400000UL

	May be something wrong with word returned at pci_read_config_word()?

		Cyrill

