Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYBJRwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYBJRwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYBJRwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:52:25 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:44936 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYBJRwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:52:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=txFnVnfX2SjPTgk4QxVmPyUdwOscQc1f7he68SBo6nL1tQxCnwut4EkSGXxrePo3VZtLps1pVk2/AeJnAo5L/BtePAD/+zk+W0rirJhvJSQyL0Ubkt6GLNAR+CHDXordwtw4Ss+TGRcNVsRK9/KzTJ794Wvw86q/5gERFN7VVgo=
Message-ID: <2c0942db0802100952k3baec233h5adb22dfd795b72b@mail.gmail.com>
Date: Sun, 10 Feb 2008 09:52:22 -0800
From: "Ray Lee" <ray.lee@tapsys.com>
To: "Mirco Tischler" <mt-ml@gmx.de>
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
Cc: lkml <linux-kernel@vger.kernel.org>, "Len Brown" <len.brown@intel.com>,
       "Pavel Machek" <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1202664109.8394.19.camel@mtlp>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202664109.8394.19.camel@mtlp>
X-Google-Sender-Auth: a16e074fd090d05d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 9:21 AM, Mirco Tischler <mt-ml@gmx.de> wrote:
> Hi
>
> I think I found a regression in 2.6.24-git. After waking up from suspend
> 2 ram, the fan of my laptop turns constantly at highest speed. It didn't
> do this in 2.6.24.
>
> I bisected it down to this commit:
>
> commit c95d47a868f35cd47643d116a3c680cdaa954df8
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Tue Jan 8 00:05:21 2008 +0100
>
>     ACPI: Separate invocations of _GTS and _BFS from _PTS and _WAK
>
> Reverting it resolves the problem for me, but I can't say if this makes
> any sense.
>
> My machine is a Zepto laptop with Intel Santa-Rosa chipset and I'm
> running
> a x86_64 Ubuntu Gutsy.

I just noticed the same problem. After about ten minutes, it seems
like all the ACPI events got 'unstuck' -- my screen's backlight went
up and down a couple of times (and battery/AC indicator flipped a
couple of times) responding to previous power loss and gain events, I
think, and the fans dropped down from high speed to low.

I was chalking it up to another charming bug on my HP nx6125, but if
someone else is seeing it too...

I'm on Ubuntu, x86_64, and git as of a couple days ago as well. I
haven't tried reverting the patch.
