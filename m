Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbXKAXcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbXKAXcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXKAXcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:32:23 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:32102 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753717AbXKAXcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:32:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mnx9GHNJGDao2xdP7SwZUP4TQ6vMQsn4bZfQ2DOUZ2lJaUhuMtwrnIbM8j8zO49Y2yAwmow6zfhwXQozwI6Sjzdb4asoOsBBVqEmQdwt426r4MblGRLHpyIijSbWaabSVmsT4LF7xSb/PRTRwLLv1xoTQiYvoMRTcDbMRCdIRo4=  ;
X-YMail-OSG: BWfirAMVM1lzIPEhDLy8GC7lnC3i2G441F9gLtVqve8BtHooNBgjYy0H59rxxcnm129Fnpt1Eg--
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function `usbnet_set_settings':
Date: Thu, 1 Nov 2007 16:32:18 -0700
User-Agent: KMail/1.9.6
Cc: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
References: <200711012024.57412.toralf.foerster@gmx.de> <20071101141124.0cbe2897.randy.dunlap@oracle.com>
In-Reply-To: <20071101141124.0cbe2897.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711011632.18333.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007, Randy Dunlap wrote:
> The MII functions aren't available unless NET_ETHERNET=y.
> Howver, the MII functions aren't always needed...
> 
> David, any ideas on this one?

It's been several years since I looked at this.  It
used to behave just fine.

Something must have changed in the not-too-distant
past to have broken this mechanism...


>  config USB_USBNET
>         tristate "Multi-purpose USB Networking Framework"
> +       depends on NET_ETHERNET if USB_USBNET_MII != n
>         select MII if USB_USBNET_MII != n
> 
> would be handy.  But invalid.
> 
> Hm, wait.  Haven't we seen this before and decided that MII should
> be made more generally available?  I.e., not depend on NET_ETHERNET?

Some of us keep wanting to see "select" work properly,
not omitting dependencies...

Re interdependencies MII and NET_ETHERNET, I'll leave
that up to the netedev folk.

- Dave

