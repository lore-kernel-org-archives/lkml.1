Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab0BYCSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:18:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:47079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab0BYCSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:18:13 -0500
Message-ID: <4B85E038.20905@kernel.org>
Date: Thu, 25 Feb 2010 11:28:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, david-b@pacbell.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
References: <4B7CAF95.6020306@gmail.com> <20100218052223.GA13254@kroah.com>	 <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>	 <201002192139.46189.david-b@pacbell.net>	 <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>	 <SNT125-W457447CBE941D2703E98D0C3420@phx.gbl> <51f3faa71002231626q1eb62adeo660c282418f0e01@mail.gmail.com>
In-Reply-To: <51f3faa71002231626q1eb62adeo660c282418f0e01@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 02:18:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/24/2010 09:26 AM, Robert Hancock wrote:
> The fact that Windows 7 is now using the feature also means that there
> aren't likely to be too many machines where the 64-bit addressing is
> reported but doesn't work. Which means that aside from the NVIDIA
> quirk, I think enabling 64-bit addressing should be relatively safe.

(following thread from the ATA side) I'm with Greg on this.  USB2.0 is
quite slow on today's standard and most 64bit machines now have IOMMU
of some kind anyway.  If we have problems on IOMMU (sw or hw)
allocation, I think it should be fixed there.

64bit support even in libata was quite painful with quirky BIOSen, PCI
host controllers, bridges and the controllers themselves.  ATA being a
major secondary storage subsystem, libata had to do it but even then
for many those enabling trials, I think we've lost more than we
gained.  There just isn't much point in trying to enable a shiny new
feature on an aging platform or technology.  The gain might be there
but the downside is we end up catching fallout cases where boot fails
or data corrupts after many months later if we're very lucky.  It's
just not worth it.

Thanks.

-- 
tejun
