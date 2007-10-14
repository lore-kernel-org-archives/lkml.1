Return-Path: <linux-kernel-owner+w=401wt.eu-S1763025AbXJNUbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763025AbXJNUbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbXJNUa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:30:59 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:52335 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbXJNUa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=l8Rxqqr9z+pgCEUKaaUS7PzRQIloZzHByoumvtdfK2fMccr7g5DxL9wziUYWe+LYr8hLYQovWoRzA2FZRH7wrZ8pGX/pyLGXNoffKoYnRTglYFhb8s1e45mjjkuK3JrpGxeGlxk2xzkc/L7fCniTTWOyo/naT7a+p9VEqiCRQyo=
Message-ID: <71b295590710141330g7a4779e5q2d6b8f50387ee971@mail.gmail.com>
Date: Sun, 14 Oct 2007 15:30:57 -0500
From: "Mark Weber" <crash@treysoft.com>
Reply-To: crash@treysoft.com
To: "Bart Samwel" <bart@samwel.tk>
Subject: Re: hdparm standby timeout not working for WD raptors?
Cc: "Mark Lord" <lkml@rtr.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <47120D65.3080008@samwel.tk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>
	 <470E7B90.5060203@rtr.ca>
	 <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>
	 <470F7705.3@rtr.ca>
	 <71b295590710121519i55d3471fha16210e698094bec@mail.gmail.com>
	 <47120D65.3080008@samwel.tk>
X-Google-Sender-Auth: 25153cdd19f89d57
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Bart Samwel <bart@samwel.tk> wrote:
>
> Some things to check:
>
> * Run "hdparm -I" on your drive. In the "Capabilities" section there is
> a line "Standby timer values", for some drives this mentions a device
> specific minimum. I know some drives that ignore any setting below 60
> seconds.
>
> * I also know of quite a number of drives where hdparm -B settings
> override the -S settings, even if you set the -S settings after the
> hdparm -B settings. You could try combinations with various values of
> hdparm -B, especially 1 and 255.

Thanks for the suggestions.

The -I command prints out a bunch of stuff including:
Standby timer values: spec'd by Standard, with device specific minimum

I tried setting -B to 1 and and then set -S to 5 minutes.
Also, -B 255 and then set -S to 5 minutes.
No luck with either. These drives want to keep running.

One thing of possible interest: The -B command printed
the following message:

/dev/sda:
 setting Advanced Power Management level to 0x01 (1)
 HDIO_DRIVE_CMD failed: Input/output error

I would guess that the first line came out just before
hdparm tried to do the set, and the second line indicates
that the set failed.

Perhaps -S is failing too, just without the diagnostic?

All of the above using 2.6.22-gentoo-r5
I have not yet tried 2.6.23 as suggested by Mark Lord.

---

"And he puzzled three hours, `till his puzzler was sore."
from "How the Grinch Stole Christmas"
