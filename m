Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZKJRau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZKJRau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZKJRat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:30:49 -0500
Received: from mail-px0-f173.google.com ([209.85.216.173]:34399 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbZKJRat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:30:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M1GcissjzpG4lJ7eOWmC/JVSQ6gEP4G/ijlDr5S8piHVSdQhvepTzD+S672Od1fb28
         6K9FSVGKsxS0O4DMTpiIDGQjAPKhsZP3hutNarodDqv6bR9oYfqSNMblF5ra2fo6FXli
         qvHud7eNMtPeUk6plEHsYCtkKkkXoGa+fwO1c=
Date: Tue, 10 Nov 2009 09:30:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [PATCH] ALPS: Add support for 4 directions button on Acer
	Aspire 5720
Message-ID: <20091110173047.GC15263@core.coreip.homeip.net>
References: <1256955018.9681.23.camel@maxim-laptop> <1257846940.4921.11.camel@maxim-laptop> <1257847427.4921.13.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257847427.4921.13.camel@maxim-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxim,

On Tue, Nov 10, 2009 at 12:03:47PM +0200, Maxim Levitsky wrote:
> @@ -483,8 +529,13 @@ int alps_init(struct psmouse *psmouse)
>  	}
>  
>  	if (priv->i->flags & (ALPS_FW_BK_1 | ALPS_FW_BK_2)) {
> -		dev1->keybit[BIT_WORD(BTN_FORWARD)] |= BIT_MASK(BTN_FORWARD);
> -		dev1->keybit[BIT_WORD(BTN_BACK)] |= BIT_MASK(BTN_BACK);
> +		dev1->keybit[BIT_WORD(BTN_0)] |= BIT_MASK(BTN_0);
> +		dev1->keybit[BIT_WORD(BTN_1)] |= BIT_MASK(BTN_1);
> +	}
> +
> +	if (priv->i->flags & ALPS_EXTRA) {
> +		dev1->keybit[BIT_WORD(BTN_2)] |= BIT_MASK(BTN_2);
> +		dev1->keybit[BIT_WORD(BTN_3)] |= BIT_MASK(BTN_3);
>  	}
>  

Please don;t do this, you are breaking existing users. Add
ALPS_FOUR_BUTTONS flag and use it to report BTN_0..BTN_3 in your case.

I am also unsure if we need to do DMI entry, I'll try to dig original
submisison for that signature and see...

Thanks.

-- 
Dmitry
