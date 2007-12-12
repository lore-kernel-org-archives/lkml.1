Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbXLLOKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbXLLOKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXLLOKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:10:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:58880 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXLLOKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pt8FDocvgCZ76Ua97/YREyxLVkJQBgosdTY8P74QcHRgCne8PQs5dK8/4P2SSSI39gyTxyiF3AvxzfQL98D7CD19BrHuPKenBqCZKQKE/SrEQyjPVL34SBrkZq4pcMamUsxnhrMx35dJ6NBxHHGZJdy7ZBONxrLJHPm9sd5QQ/A=
Message-ID: <d120d5000712120610m30c054f5w596c29a1700211f@mail.gmail.com>
Date: Wed, 12 Dec 2007 09:10:31 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Fujitsu application panel driver
Cc: "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20071023125555.38d63567@shemminger-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
	 <200709140130.59732.dtor@insightbb.com>
	 <20070916215516.2934abad@oldman.hemminger.net>
	 <200709161623.00286.dtor@insightbb.com>
	 <20071023125555.38d63567@shemminger-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Oct 23, 2007 2:55 PM, Stephen Hemminger
<shemminger@linux-foundation.org> wrote:
> +static void mail_led_set(struct led_classdev *led,
> +                        enum led_brightness value)
> +{
> +       struct apanel *ap = container_of(led, struct apanel, mail_led);
> +       if (value)
> +               ap->led_bits |= 0x8000;
> +       else
> +               ap->led_bits &= ~0x8000;
> +       ap->led_bits = value;
> +       schedule_work(&ap->led_work);
> +}

I was just about to apply the driver (and I folded in the other 4
patches you sent to me) but then I noticed the code above. It looks
like the conditional does not have any effect, ap->led_bits will be
overwritten with the raw value anyway. Please advise.

Thank you.

-- 
Dmitry
