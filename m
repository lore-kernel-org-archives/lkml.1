Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbYKQPJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbYKQPJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYKQPJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:09:24 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:41100 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYKQPJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:09:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ZWw4llPgn6gE6y77pn1t+qUivW4FMAkiJNvsI1lmYs5pFf65aI5/s8mF/K7zvU/yfJ
         HypgerFq2wvzmZz3aEnVtDTOdrqfn0vrV8EcaSbqnYNd9y0A9aWgxg4dnCBkWJLqm1f8
         u75f62Uy68nQF90HJ2bMFw6tS1tIfYTxX558E=
Message-ID: <9b2b86520811170709o4581a064v957ae41403b6113@mail.gmail.com>
Date: Mon, 17 Nov 2008 15:09:21 +0000
From: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [Patch 2/3] eeepc-laptop: Check return values from rfkill_register
Cc: "Corentin Chary" <corentin.chary@gmail.com>, ecc@cmu.edu,
       "linux acpi" <linux-acpi@vger.kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081117133804.GD12303@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081117133325.GB12303@srcf.ucam.org>
	 <20081117133510.GC12303@srcf.ucam.org>
	 <20081117133804.GD12303@srcf.ucam.org>
X-Google-Sender-Auth: 37196213468c5635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/08, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> We should check that rfkill registration succeeds and error out if it
> doesn't. This patch also sets the default state to match the BIOS on
> load.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
>
> diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c

You change the usage of the "end" label so it's now only reached on
failure.  How about renaming it to "fail" or "ehotk_fail"?  Also, it
looks like "if (result)" is now redundant - result will always be
non-zero in the error path.

> +	return 0;
>
> + bluetooth_fail:
> +	if (ehotk->eeepc_bluetooth_rfkill)
> +		rfkill_free(ehotk->eeepc_bluetooth_rfkill);
> +	rfkill_unregister(ehotk->eeepc_wlan_rfkill);
> +	ehotk->eeepc_wlan_rfkill = NULL;
> + wlan_fail:
> +	if (ehotk->eeepc_wlan_rfkill)
> +		rfkill_free(ehotk->eeepc_wlan_rfkill);
>   end:
>  	if (result) {
>  		kfree(ehotk);
