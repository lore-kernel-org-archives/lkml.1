Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYGPSmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYGPSmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 14:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYGPSmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 14:42:12 -0400
Received: from outbound-mail-32.bluehost.com ([69.89.18.152]:48528 "HELO
	outbound-mail-32.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752114AbYGPSmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 14:42:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=eddGOz1KH4SDWwx+X4R456SodE0n6ov5IOig3poyDY9gpK8AzqdV/muSyv6wk9szEgN+9m6/ebMl69161dw4FSYFHchKmygL2ukBj4gPRUS71LnFHAazONn1U1X8/ZHr;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 5/5] Ath5k: suspend/resume fixes
Date: Wed, 16 Jul 2008 11:41:59 -0700
User-Agent: KMail/1.9.9
Cc: Nick Kossifidis <mickflemm@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com> <200807160931.11473.jbarnes@virtuousgeek.org> <1216229703.29744.23.camel@dv>
In-Reply-To: <1216229703.29744.23.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161141.59385.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2008 10:35 am Pavel Roskin wrote:
> On Wed, 2008-07-16 at 09:31 -0700, Jesse Barnes wrote:
> > On Wednesday, July 16, 2008 9:15 am Nick Kossifidis wrote:
> > > It's ok for now, but have in mind that on my upcoming patch series i'm
> > > disabling msi (commented out) since it results no interrupts on pci-e
> > > cards (seems there is a bug in kernel's msi implementation).
> >
> > Hm, would be good to get details here.  MSI is being used by other
> > drivers successfully...
>
> That's true, but no driver uses the same interrupt handler with and
> without MSI.  Either it's different handlers or the handler checks if
> MSI is enabled and does something differently.

Yeah, using MSI on your device can mean that you have to make some changes 
(like on Intel graphics you have to disable regular interrupts or bad things 
happen), but you can still share the handler or at least most of it in some 
cases.

> Checks is any interrupts are pending are different for MSI.  It may be
> not hard to do (it's probably easier than for real interrupts), but it
> has to be figured out.  Somebody has to do it right.  Until MSI is
> supported by the interrupt handler, it should not be enabled by the
> driver, or we get a non-functioning driver for AR5006.

Sure, that's fine.  I just wanted to make sure that there weren't some weird 
generic MSI problems.

Thanks,
Jesse
