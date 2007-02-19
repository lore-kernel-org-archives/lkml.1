Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbXBSFw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbXBSFw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 00:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXBSFw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 00:52:58 -0500
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:45629 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752962AbXBSFw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 00:52:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=C2FbKc+i3Oh70kjhZDtHZoV4QS6RYhVvW053JCuaXIR1fSAI1XzxZsbjrIlYeWoZz1r0hWEiK0iHW6cv7uBn3JNLgWB8T8rOqevtx16qRLFHW9dC8Oc6lXRpURz1ieKKZKC9KuXnxAvoX64YkuuWwfqUvGTNn0JH6lfnzcUUAYw=  ;
X-YMail-OSG: mduTJroVM1lSxugr7lYhYmV9gMWupY.03Rddjq_vlXgN6Ewdid5DcGSfgB9O6.Zl0PuuTruMUU65iQ696Zbbf8kdi3KvSVSdY9KQQF.MTybM9fEncdMYKp30bz1WxK.xDSGiwOh34zclDkU-
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch/rfc 2.6.20-git] parport reports physical devices
Date: Sun, 18 Feb 2007 21:52:53 -0800
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>
References: <200702182108.08217.david-b@pacbell.net> <20070218212835.3bf2f248.randy.dunlap@oracle.com>
In-Reply-To: <20070218212835.3bf2f248.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702182152.54105.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 February 2007 9:28 pm, Randy Dunlap wrote:
> On Sun, 18 Feb 2007 21:08:07 -0800 David Brownell wrote:
> 
> > Currently a parport_driver can't get a handle on the device node for the
> > underlying parport (PNPACPI, PCI, etc).  That prevents correct placement
> > of sysfs child nodes, which can affect things like power management.
> > 
> > This patch resolves that issue for non-legacy configurations:
> > ...
> 
> Does this patch address http://bugzilla.kernel.org/show_bug.cgi?id=5496 ?

I don't think it would affect that behavior, but surprises can happen;
like the root cause of 5496 being the lack of hookup to the real device.


> What are you wondering about parport DMA?

First, whether it ever worked on ports enumerated through PNP.

After all, I saw it oops there, ergo the surprisingly-far-afield
parts of this patch to update PNP so it now sets up DMA masks.
(Which, I was thinking, probably matters mostly for parport;
but I'm just assuming 24-bit masks are correct there.)


> Please see http://bugzilla.kernel.org/show_bug.cgi?id=7491
> and http://bugzilla.kernel.org/show_bug.cgi?id=7492

Suggesting that no, it's never worked on ports enumerated
through PNP.  There's a possibility that if it previously
worked through PCI, it now works ... someone with a parport
printer could check it out.

- Dave

