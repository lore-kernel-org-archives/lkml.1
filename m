Return-Path: <linux-kernel-owner+w=401wt.eu-S1764694AbYDNSIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764694AbYDNSIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYDNSIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:08:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:32603 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbYDNSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:08:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rSZyElrK2N/gPTXjgPnAflaKA3SNQt9VH79CBgKeweFgoqhw+oabynLO/A0j6Bs0kORZ1ToDXXivIMG7rTqQc6LAC/ms2pjt/Yxtlke9nPXeLMa73v4H9E6XY3pqrVrmdo8WqKqGVIsP+rGkijEo9aPrB6BTVcDJVj6dbsjn2lg=
Message-ID: <86802c440804141108l1fd922b3tf566569bc4dc6767@mail.gmail.com>
Date: Mon, 14 Apr 2008 11:08:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86 git tree broken (bisected)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20080414091600.GI19865@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <200804140010.01034.rjw@sisk.pl>
	 <86802c440804131532g4626233br82a425d6a96a6e11@mail.gmail.com>
	 <200804140219.07350.rjw@sisk.pl>
	 <86802c440804131842t16d05976g20b2eb97af6bbf1b@mail.gmail.com>
	 <20080414091600.GI19865@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 2:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>
> > >  Attached is dmesg output from current x86.git with
>  > >  debug_gart_checking.patch applied.
>  >
>  > please test the final one ... ...
>  >
>  > You should get back 64M memory back.
>
>  so basically with all the right patches applied, and GART set to 32MB in
>  the BIOS, Rafael should have more free RAM on his system than ever
>  before :-)

Yes

>
>  i've put all the patches into x86.git/latest (it's all uploaded already
>  as well), so that should give Rafael a one-stop shop to test it out. [i
>  have not applied the debug patch that changes the aperture test from
>  32MB to 64MB, and it should be unnecessary as well]
>
>  btw., Yinghai, should we perhaps add a WARN_ON() to those places where
>  we waste RAM (such as the "This costs you 64 MB of RAM" message) - so
>  that kerneloops.org can pick those warnings up? Maybe there are other
>  situations where we waste RAM, and people dont realize it.

in Rafael case, just need to ask user to increase GART size in BIOS if
more than 4G RAM installed ( or 4G installed with hardware memhole
remapping enabled).

if less than 4G installed, just take the BIOS setting with 32M

YH
