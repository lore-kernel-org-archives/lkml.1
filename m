Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZBPRsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZBPRsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 12:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZBPRsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 12:48:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:9720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZBPRsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:48:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a6QdsOWlgmesGHqzD58m54SmATMjApojZtgKaPsTg3x/wky7vhesqmsnS4LwtzoZmS
         Ra/OGmEdD2Z1QEygda14pYQaWpWLDgYyT8qnZw+bXIOD49NMITGze7WVjFywX3QlYYd/
         4P2FtnRbODEKZqWf5Yk0Zt3Cwut+i9q35FQg8=
Subject: Re: [patch 41/47] bluetooth hid: enable quirk handling for Apple
 Wireless Keyboards in 2.6.27
From: Torsten Rausche <torsten@rausche.net>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
       Paul Collins <paul@burly.ondioline.org>
In-Reply-To: <873aegws3k.fsf@scholz.fias.uni-frankfurt.de>
References: <20090214005130.617401075@mini.kroah.org>
	 <20090214005924.GP11282@kroah.com>
	 <873aegws3k.fsf@scholz.fias.uni-frankfurt.de>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 18:48:34 +0100
Message-Id: <1234806514.3659.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Scholz writes:
> A very similar fix has been proposed by Paul Collins (see
> http://lkml.org/lkml/2008/6/14/26 ) a while ago.

Good catch, did not see that. This is essentially the same fix. One more
reason to let it go in.

> Here on my ppc32 G4 it works only if I apply the following as well.
> I can't test it on x86, though.
> 
> Jan Scholz
> 
> --
>     removed 2 calls to le16_to_cpu from the bluetooth hid quirks
>     
>     seems we're doing some endianness conversion one time to much
> 
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index 28dc035..6b95a6d 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -699,8 +699,8 @@ static void hidp_setup_quirks(struct hid_device *hid)
>         unsigned int n;
>  
>         for (n = 0; hidp_blacklist[n].idVendor; n++)
> -               if (hidp_blacklist[n].idVendor == le16_to_cpu(hid->vendor) &&
> -                               hidp_blacklist[n].idProduct == le16_to_cpu(hid->product))
> +               if (hidp_blacklist[n].idVendor == hid->vendor &&
> +                               hidp_blacklist[n].idProduct == hid->product)
>                         hid->quirks = hidp_blacklist[n].quirks;
>  }

Well, then the wireless Mighty Mouse should never have worked on ppc. I
just tested these changes on my x86_64 box and the keyboard still works
fine.

Actually this is a fix for just another problem. Should these patches be
combined? How is this handled? I am not familiar with this process.

Torsten


