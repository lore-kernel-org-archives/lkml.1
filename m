Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbXA3IcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbXA3IcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXA3IcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:32:19 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:36196 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752088AbXA3IcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:32:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=mut79F61fuu6Gl8hO90gax3FBVGbqkQR+QKNsLbO+Wtg2/heisZR9mMpY1e5t/gsZ7f7A447SPDciWwIeTfsysF0XX0Oos0patGa/kkZH3aIBxo3pZ5u5/0c2cbpBZkF2srQerUYoJNclUEsN8jgkYHc29sojYk/2QpRXaC28fo=  ;
X-YMail-OSG: HGKwzfwVM1mApes02RPEXfFh1gyjRkxTcGzgLsnVC9yCVFKdJgdGlIhWx73J4oajIr8377Iq7Q--
Message-ID: <45BF0281.2020102@yahoo.com.au>
Date: Tue, 30 Jan 2007 19:32:01 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: via irq quirk breakage
References: <45B6A94A.3010006@yahoo.com.au> <200701291600.32580.jdelvare@suse.de> <45BEAEE3.9080003@yahoo.com.au> <200701300854.06083.jdelvare@suse.de>
In-Reply-To: <200701300854.06083.jdelvare@suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

Jean Delvare wrote:

> You have an old VT82C686 south bridge, which was tagged as "special" by
> Alan. For this chip, Alan's code only allows devices 00:00.x to be quirked.
> As my code was merely a reimplementation of Alan's idea, it does the same.
> Your USB controllers are at 00:07.x, so I'm not surprised they weren't
> quirked.
> 
> Alan, why were dev_lo and dev_hi both set to 0 for the VT82C868 in your
> implementation? Is it a typo, or...?
> 
> Nick, I guess the following patch would work better for you? I've listed
> devices 00:07.x as quirkable for the VT82C686.
> 
> * * * * *
> 
> Fix VIA quirks that were recently broken by Alan Cox in the upstream
> kernel (commit 1597cacbe39802d86656d1f2e6329895bd2ef531).

Thanks for making the patch, it works like a charm now. The quirk
gets applied to both USB controllers.

> My understanding is that pci_find_present() doesn't work yet at the
> time the quirks are run. So I used a two-step quirk as is done for
> some other quirks already. First we detect the VIA south bridges
> and set the right low and high device limits, then we are ready to
> actually run the quirks on the affected devices.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
