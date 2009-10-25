Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbZJYT4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbZJYT4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZJYT4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:56:34 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:46058 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZJYT4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IHjKoiyMiLik1lYkJkgZYAvVwFOzxXcxAbrSQ3EUBnKajWO3lLN8VFP865GWroavdG
         Bd1jKvaeFfiuTHwb3lu0xxhsSstTFB5pTbc8aCKIVQ+ZJkxl3GIqAmp4syUV9X/WqXfB
         3+wrlceoH/OZ0K51BFxB9I8ziM66uwVgMQIYI=
MIME-Version: 1.0
In-Reply-To: <200910252052.09845.oliver@neukum.org>
References: <20091025175057.270011110@gmail.com>
	 <20091025175321.276761473@gmail.com>
	 <200910252052.09845.oliver@neukum.org>
Date: Sun, 25 Oct 2009 20:56:36 +0100
Message-ID: <7eb6a4d80910251256w4ad8a77dg5a24618657b77a58@mail.gmail.com>
Subject: Re: [PATCH 3/7] ark3116: (3rd try) Replace cmget
From: Bart Hartgers <bart.hartgers@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/25 Oliver Neukum <oliver@neukum.org>:
> Am Sonntag, 25. Oktober 2009 18:51:00 schrieb bart.hartgers@gmail.com:
>> +       /* read modem status */
>> +       unsigned status = atomic_read(&priv->msr);
>> +       /* modem control is output */
>> +       unsigned ctrl = atomic_read(&priv->mcr);
>
> What is the sense of having two atomic variables?
> You can get races where one is changed but the other is not.
>
>        Regards
>                Oliver
>
>

Hi Oliver,

I don't think so. The two values are not really related.

These are two separate things: mcr (modem control reg) is ultimately
changed by whatever has the serial port open, msr (modem status
register) represents the status of the handshaking lines, and is
changed (via the interrupt urb callback) by hardware.

Groeten,
Bart

-- 
Bart Hartgers - New e-mail: bart.hartgers@gmail.com
