Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZFEKf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZFEKf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZFEKfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:35:47 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:58204 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZFEKfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VIVYsDAdEnSR2BnlQ90NRCWbgdXPLtD4HVvyFpxOBOZ9DgaZHLQXZehZrXCyJNTHwd
         CSqEGXaauolgMc+BcE8vbYLGVbmlx7QRFltM8Co9fNPgptDjIkZKWC2ZB37+wo6BsCsQ
         STcE3yP6VLCAqFE1Xl8MuS3JUe0Uw0/zOpQEU=
MIME-Version: 1.0
In-Reply-To: <20090605100505.41b3b818@lxorguk.ukuu.org.uk>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	 <4A25F688.9000407@gmail.com>
	 <c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>
	 <20090603131407.57c490ed@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>
	 <20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
	 <c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>
	 <20090605100505.41b3b818@lxorguk.ukuu.org.uk>
Date: Fri, 5 Jun 2009 12:35:46 +0200
Message-ID: <c5bd819b0906050335i4e813887sc8f4d901da86a1aa@mail.gmail.com>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
From: Grozdan <neutrino8@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/5 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> Adding more information. A user on the openSUSE forum which is trying
>> out openSUSE 11.2 milestone 2 (with kernel 2.6.30-rc6-git3) is having
>> the same problems. His computer is using the pata_amd driver instead
>> of pata_via like mine and he too gets limiting to UDMA33 during boot
>>
>> Link: http://forums.opensuse.org/pre-release-beta/415373-hd-speed.html
>
> Different problem. However that Nvidia one it would be worth trying this
> so that we just rely upon the ACPI/BIOS data for Nvidia.
>
> diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
> index 33a74f1..c9c5fad 100644
> --- a/drivers/ata/pata_amd.c
> +++ b/drivers/ata/pata_amd.c
> @@ -424,7 +424,7 @@ static struct ata_port_operations amd133_port_ops = {
>
>  static const struct ata_port_operations nv_base_port_ops = {
>        .inherits       = &ata_bmdma_port_ops,
> -       .cable_detect   = ata_cable_ignore,
> +       .cable_detect   = ata_cable_80wire,
>        .mode_filter    = nv_mode_filter,
>        .prereset       = nv_pre_reset,
>        .host_stop      = nv_host_stop,
>

Hi Alan,

I've relayed your reply to the pata_amd user on the forum. As for my
case with pata_via, until this is fixed, is there any way to force it
to use a higher UDMA? Is there a flag that can be passed in, for
example, in /sys somewhere? hdparm fails to set a higher UDMA and I
looked at sdparm but don't see anything in it to increase UDMA...
