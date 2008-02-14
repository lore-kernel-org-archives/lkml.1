Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbYBNSyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbYBNSyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbYBNSx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:53:58 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:29099 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756442AbYBNSx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:53:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IZvSVmwgU9OefqSVy1/DsqOAMw5QQhjn70v7MsRedXwOlzUy9pLjyJtUVGv6Irb9Qaq6UbzZ50AhkGeiuVNxdQMZ2o/IlhWg3oi9Cs9U9Yk3HZ/zo3ZxcVAh4VSMTmBkoZyTODEE+w0Q0exqM40ovQJnUviwtrTAYq3iiJ9fl+I=  ;
X-YMail-OSG: LOPrBo8VM1n4C4ltLq6v_DwFf4euiT9dtylAbtacuqPyO9cc224p6QuW1dUfklYjfAqEwg39Yw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: Handshaking on USB serial devices
Date: Thu, 14 Feb 2008 10:53:55 -0800
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47B30291.2040905@davidnewall.com> <20080214121026.16a9c510@core> <47B482B4.9010208@davidnewall.com>
In-Reply-To: <47B482B4.9010208@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802141053.55914.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, David Newall wrote:
> RS232 is (normally) so much slower than USB that, on an extended
> transmission, the buffer internal to the local hardware can fill well
> before the remote device has demanded that transmission stop.  In fact,
> now that you've mentioned it, I can't see that anything to stop the
> driver from overflowing the internal buffer, which is very perplexing. 
> Would that be right? 

Only for stupidly designed hardware ... which you might well
be using, though I happen to never have seen anything that's
quite *that* stupid.  (There's always a first time though.)

USB has enough control flow to prevent that from happening.
If the host sends data that the peripheral isn't ready to
accept, the peripheral just refuses to accept it, and the
host will retry later.

- Dave

