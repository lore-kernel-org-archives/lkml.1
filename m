Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbZEDDip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbZEDDip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 23:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZEDDie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 23:38:34 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:3470 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZEDDid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 23:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ANBNv0bhOPfHIHtJRUGWiLTf+J9xk6X1g8oXqE1Iy2o5sVHJ/XyyyPF92QYniQ4J84
         k4Ur2U47rvm1RB1bz7gGAKiB9z/us2aXl6l2RkkMb3IyjLEZvQ23jBYzf57KE3kfON3h
         7kWnxE9AZ+nvjZz/LazCGfIRx2xydlHR0dYBE=
MIME-Version: 1.0
In-Reply-To: <200905031909.14101.oliver@neukum.org>
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com>
	 <200905031909.14101.oliver@neukum.org>
Date: Sun, 3 May 2009 23:38:33 -0400
Message-ID: <3a3680030905032038h40cd75bdrbee839117e5a4d55@mail.gmail.com>
Subject: Re: [PATCH] usb: use memdup_user()
From: Li Hong <lihong.hi@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The key is: is there any need or probability to use GFP_NOIO instead
of GFP_KERNEL _here_? It also confuses me to move the user space copy
outside of the loop.

IMHO, this is just a simple cleanup of the code.

Regards,
Hong

2009/5/3 Oliver Neukum <oliver@neukum.org>:
> Am Sonntag, 3. Mai 2009 18:00:56 schrieb Li Hong:
>> Replace a combination call of kmalloc() and copy_from_user() with
>> memdup_user().
>
> To be precise. copy_*_user() of course implies that you can do
> GFP_KERNEL. But the point is one of design. Right now I can change
> locking and if that means that one must use GFP_NOIO, which is common
> in usb due to the storage driver, we can find out by simply grepping and
> move the user space copy outside of the loop.
>
> If you make that change we must grep against a second and rare
> key.
>
>        Regards
>                Oliver
>
>
