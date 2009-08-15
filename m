Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZHOK7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZHOK7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZHOK7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:59:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:53227 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZHOK7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:59:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eoSixd8OUF71KYjjyVthpsXaNxkJSKfVKa5in3Vfv/LUYNOl8hAAFLJn9hcXGlgGIj
         D3v0Hn+KJi4zvYv4hMxvxWuRFgmnl3iV1vpew7ii1rJFPEGUQ0/IQaRXq3Vvgj8Yp33L
         j/BEA+L3xlQIvN+63oMOmu0D998utdfY5uBBk=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <200907011532.34677.david-b@pacbell.net>
References: <20090610001033.27b7f69f@mycelium.queued.net>
	 <17be05570906111311s717f126cyd4edf0847b839eef@mail.gmail.com>
	 <20090611172850.6c418b1d@mycelium.queued.net>
	 <200907011532.34677.david-b@pacbell.net>
Date: Sat, 15 Aug 2009 12:59:48 +0200
X-Google-Sender-Auth: 2a2b6e9fd5017c0d
Message-ID: <17be05570908150359t2cfafac3if43a2dc55a1a7195@mail.gmail.com>
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver 
	support
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: David Brownell <david-b@pacbell.net>
Cc: Andres Salomon <dilinger@collabora.co.uk>, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>, deepak@laptop.org,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       linux-geode@lists.infradead.org, jordan@cosmicpenguin.net,
       cjb@laptop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/2 David Brownell <david-b@pacbell.net>:
> Correct-but-annoying ... and maybe worth changing.  The
> direction *displayed* may not reflect the actual hardware
> until after that GPIO signal is initialized.  Boot firmware
> may well have set the direction; Linux shouldn't change it
> without explicit instructions to do so.
OK. If this is a know problem with all GPIO drivers, we can
skip these to two lines to set in pin a defined state.

> So it would be nice to remove the heuristic.  The best
> way would be to add a new method to query gpio direction.
> Then that when it's available, instead of the heuristic.
This can be implemented when the GPIO interface supports it.

The problem with the mask still occurs. I changed to default
mask to 0x0F7FFFFF, so that all pins except the reserved
ones and the power-pin (which needs special handling) are
enabled. Shall we keep it this way (which I prefer) or delete
it entirely?

Sorry, for the late reply, holidays were nice. :)
  Tobias
