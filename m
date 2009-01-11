Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbZAKJ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbZAKJ4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZAKJ4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:56:30 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:1277 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZAKJ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:56:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Lu+aVSbnCJj6vRDbYFDXArrGEQ+CDsGh89Fj1H5pgajWn0Xmcru1gHN184EV/YWorP
         ZzoU3rhHK+snUN/AOQdBGwXv/q9jQS9DKhCK7XvpdpNlqgKHx8hxcvcC5si3j7uChtH2
         anOX498Vp5bS1J1nAlOUfhnx0hLJzo01G2qDA=
Message-ID: <21d7e9970901110156p3e795ad6ub72c6796adeda61a@mail.gmail.com>
Date: Sun, 11 Jan 2009 19:56:28 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Graham Murray" <graham@gmurray.org.uk>
Subject: Re: [git pull] drm
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87priu5gyb.fsf@newton.gmurray.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
	 <1231513655.5317.30.camel@dax.rpnet.com>
	 <87priu5gyb.fsf@newton.gmurray.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 7:29 PM, Graham Murray <graham@gmurray.org.uk> wrote:
> Richard Purdie <rpurdie@rpsys.net> writes:
>
>> Hi,
>>
>> I just updated to the latest kernel from git to test some other patches
>> and after logging into GDM the X server hangs before launching the
>> desktop (it appears to be trying to run glxinfo) on my Thinkpad T61
>> (i915 graphics). Bisection shows this happens after applying this
>> commit:
>>
>> On Mon, 2008-12-29 at 08:32 +0000, Dave Airlie wrote:
>>> Please pull the 'drm-next' branch from
>>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next
>> [...]
>>> commit 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
>
>
> I am seeing a similar, but slightly different problem which I bisected
> to that same commit. I am using radeonfb and the radeon X driver and I
> can log into kdm with no problems and work, but once I switch to a
> 'normal' console with CTL+ALT+Fn when I switch back to X it is dead with
> the top, approximately 1/3, of the screen corrupted and keyboard and
> mouse dead. I can get out of it by SAK+K which kills X and returns to
> the kdm logon screen. There are no ooops or any other indications apart
> from logging the SAK action.

Can you open a bug on bugzilla.kernel.org with the Xorg log,

I really dislike running radeonfb and X unless its on powerpc, does it
work without radeonfb?

Dave.

>
> 06:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)] (prog-if 00 [VGA controller])
>        Subsystem: C.P. Technology Co. Ltd Device 2090
>        Flags: bus master, fast devsel, latency 0, IRQ 16
>        Memory at d0000000 (32-bit, prefetchable) [size=256M]
>        I/O ports at c800 [size=256]
>        Memory at ff9f0000 (32-bit, non-prefetchable) [size=64K]
>        Expansion ROM at ff9c0000 [disabled] [size=128K]
>        Capabilities: [50] Power Management version 2
>        Capabilities: [58] Express Endpoint, MSI 00
>        Capabilities: [100] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
>                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
>        Kernel driver in use: radeonfb
>
> 06:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
>        Subsystem: C.P. Technology Co. Ltd Device 2091
>        Flags: bus master, fast devsel, latency 0
>        Memory at ff9e0000 (32-bit, non-prefetchable) [size=64K]
>        Capabilities: [50] Power Management version 2
>        Capabilities: [58] Express Endpoint, MSI 00
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
