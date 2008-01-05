Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYAERw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYAERw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 12:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYAERwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 12:52:19 -0500
Received: from smtp107.plus.mail.mud.yahoo.com ([68.142.206.240]:45326 "HELO
	smtp107.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754105AbYAERwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 12:52:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ILm1ULRwitJvhwicwEvbMjUvFwtRj2PF+MTyxrlijz+/YdsZkRB+2fmtPXBsd4cdwQfFGN4CDbyIbVqdTp/5vunSITkMKBaK0CF1D4hJVuwSXvY47lrfRTvOL2qaNOcR/tVcIJBsVi4nIjSEhGSDUwwvM2I0Wsw0EH5ZT82LaUA=  ;
X-YMail-OSG: FJ20BkgVM1lJ_mTTIeuX5Vc1PhWxQZrTUYcERqXW7egxyyqNEtF6gIud7w8oPiv7AQ76SWCYjg--
Message-ID: <477FC3C6.8070607@yahoo.fr>
Date: Sat, 05 Jan 2008 18:52:06 +0100
From: =?ISO-8859-1?Q?R=E9mi_H=E9rilier?= <rherilier@yahoo.fr>
User-Agent: Thunderbird 2.0.0.9 (X11/20071212)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, dtor@mail.ru,
       linux-input@vger.kernel.org
Subject: Re: wistron_btns-add-support-for-x86_64-systems.patch in -mm
References: <20071223144756.GA4827@basil.nowhere.org>
In-Reply-To: <20071223144756.GA4827@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> While looking for something else I stumbled over
> 
> wistron_btns-add-support-for-x86_64-systems.patch
> 
> in -mm. The patch looks very dubious to me. It basically
> calls a BIOS function in long mode. To work like implemented
> the BIOS would need to know magically what it was called
> from (32bit or 64bit) and then execute different code paths.
> 
> It's very unlikely that this works. Most likely 
> it will crash and if it happens to currently work 
> it will be extremly fragile and crash at some future
> point.
> 
> If anything you would need to set up a compat mode segment
> and call the BIOS from that, but there are other problems
> like interrupts not working etc (compat mode is somewhat
> limited). Early in the x86-64 port there was a decision
> to not call any BIOS calls from long mode because of these
> problems. 
> 
> The only sane way to call that code would be to do so
> from user space using some kind of emulator (e.g. like
> the x server does) 
> 
> So I think the patch should be dropped.
> 
> -Andi
> 
> 

Thanks you for your reply and these informations.

What about finding what does this BIOS function and writing
an equivalent in C? There would be no BIOS call anymore and
this module could be used in the x86-64 port.

But, is it a sane solution?


Remi




