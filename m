Return-Path: <linux-kernel-owner+w=401wt.eu-S965415AbZLHRcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415AbZLHRcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 12:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965369AbZLHRcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 12:32:12 -0500
Received: from mail-vw0-f197.google.com ([209.85.212.197]:35197 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965340AbZLHRcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 12:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QNWC2W55YTzuZeUAV4HeOPnVdZsU+N8aw3loLG8FCD+FJKv+5heI9nW7gUfWR9ydNE
         tgI/NHKBtxMh+B7+iWVlXQchqpt2xZPzuyqKeElvc/NrKFeaVP64MUCU6wPy5GgDtqm7
         cvQL2X/8qvWqgCcf4j74XjrFLBsCmFEuC/9lc=
MIME-Version: 1.0
In-Reply-To: <20091208154154.GA26435@srcf.ucam.org>
References: <1260257829-7343-1-git-send-email-ike.pan@canonical.com>
	 <20091208154154.GA26435@srcf.ucam.org>
Date: Tue, 8 Dec 2009 18:32:15 +0100
Message-ID: <71cd59b00912080932nf334ba7uf65c70178fec41a5@mail.gmail.com>
Subject: Re: [Resend] [PATCH] asus-laptop: add Lenovo SL LenovoCare LED 
	support
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ike Panhc <ike.pan@canonical.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Alexandre Rostovtsev <tetromino@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 4:41 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Dec 08, 2009 at 03:37:09PM +0800, Ike Panhc wrote:
>
>>  ASUS_HANDLE(rled_set, ASUS_HOTK_PREFIX "RLED");      /* W1JC */
>>  ASUS_HANDLE(pled_set, ASUS_HOTK_PREFIX "PLED");      /* A7J */
>>  ASUS_HANDLE(gled_set, ASUS_HOTK_PREFIX "GLED");      /* G1, G2 (probably) */
>
> The driver is controlling the ATKD device, which has a HID of ATK0101.
> These devices are all underneath it...
>
>> +ASUS_HANDLE(lled_set, "\\_SB_.PCI0.SBRG.EC0_.HKEY.TVLS"); /* LenovoCare */
>
> And this one isn't, which is a bit jarring. Looking closer, it's under
> the LEN0014 device, which means that you're trying to touch a method
> that belongs to a device other than the one this driver is bound to.
> That's wrong. You want a separate ACPI driver for the LEN0014 device,
> and this should be called for there. Looking at it, you seem to get
> rfkill as well (the GWAN/SWAN, GBDC/SBDF and GUWB/SUWB methods) and
> maybe some other stuff.
>
> So this shouldn't go in asus-laptop. You'll need to add another separate
> driver for the SL-specific functionality.

That means asus-laptop and sl-laptop will be both needed for a SL
laptop, but I don't think this is a problem.



-- 
Corentin Chary
http://xf.iksaif.net
