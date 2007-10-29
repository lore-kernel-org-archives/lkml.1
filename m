Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbXJ2MzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbXJ2MzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXJ2MzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:55:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:32917 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbXJ2MzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B/NHbQpbp4oKkv7eqyGlMeDoiJGz4ADzm9GErbEAxaKFsiBBIWuNCxRYaxipQkLnm1LVasNmcMY3+4Gsf/N2mT1VISo25O63yzxlrEKrGE78qIyQYEdoXCWQkhDZjyDaJdPRDbW66WAHXlwMWQ4syajkA3SedKFJvt+WMd5QN0k=
Message-ID: <d120d5000710290554x618eca05tbf864a0f7f9b77a5@mail.gmail.com>
Date: Mon, 29 Oct 2007 08:54:59 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from input_register_device
Cc: "Dirk Hohndel" <hohndel@linux.intel.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0710291113450.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029084917.GA12968@bigserver.hohndel.org>
	 <Pine.LNX.4.64.0710291113450.18815@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Mon, 29 Oct 2007, Dirk Hohndel wrote:
>
> > [INPUT] hidinput_connect incorrectly ignored return value from
> > input_register_device
> > Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
>
> Will apply

Please don't - the fix is completely broken for multi-input devices -
if 2nd device fails to register we bail out of hidinput_connect and
thus never set HID_CLAIMED_INPUT bit. So when we disconnect device we
never call hidinput_disconnect and who knows what will happen after
that.

hidinput_connect() should properly unwind already registered devices
after failure.

-- 
Dmitry
