Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbXJ2Pda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbXJ2Pda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXJ2PdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:33:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:27375 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbXJ2PdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:33:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WDKIy/z3Ukkt/GRqMyXM+JMnjzKBMZLjaeOVBEzc+utmmjgxbYCI2WWO25VDMB0BP/Oki1IPYuU2j2w4PuuG5RWTV6ewOAcpRiokBPRzzbl/d/i5LpvNdWJ7opuks0gX+EtoaKOkrW9Z3YhUWDazVqu3ULu9gfWmQer+wqOqy6o=
Message-ID: <d120d5000710290833i5ed524d6ne95fc1ef34834566@mail.gmail.com>
Date: Mon, 29 Oct 2007 11:33:19 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Dirk Hohndel" <hohndel@linux.intel.com>
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from input_register_device
Cc: "Jeff Garzik" <jeff@garzik.org>, "Jiri Kosina" <jikos@jikos.cz>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20071029152050.GA23411@bigserver.hohndel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4725F2DF.1060500@garzik.org>
	 <20071029152050.GA23411@bigserver.hohndel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Dirk Hohndel <hohndel@linux.intel.com> wrote:
>
> Actually, the more I look at the code that bails when it runs out of memory,
> the more I wonder about that.
>
>        hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
>        input_dev = input_allocate_device();
>        if (!hidinput || !input_dev) {
>                kfree(hidinput);
>                input_free_device(input_dev);
>
> This either passes a NULL pointer to kfree or to input_free_device. That's
> not nice.
>

No, that's allright. input_free_device() takes after kfree() so that
it safe to call it with NULL pointer.

-- 
Dmitry
