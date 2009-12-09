Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbZLIHri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbZLIHri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZLIHrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:47:36 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52391 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZLIHrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KvcK1gq6LXyQLnH26/MGrIqfIF9rZOC+OF6JA9qxqnstwQ+fVw3c25aWHn2Hkd4QnE
         fp5ASOl4paVmpx8Fob18woeudiVb1GOqmj0tzKRZZtWMGvmptosuGnA2vomXaNfNy8OP
         R2sm4+uYqp6eNTLWIJiw9w+PWWx0DsBKr2wqc=
MIME-Version: 1.0
In-Reply-To: <4B1F4963.3070405@canonical.com>
References: <1260257829-7343-1-git-send-email-ike.pan@canonical.com>
	 <20091208154154.GA26435@srcf.ucam.org>
	 <71cd59b00912080932nf334ba7uf65c70178fec41a5@mail.gmail.com>
	 <4B1F4963.3070405@canonical.com>
Date: Wed, 9 Dec 2009 08:47:41 +0100
Message-ID: <71cd59b00912082347m34dc023ds6004ca68e0bb184d@mail.gmail.com>
Subject: Re: [Resend] [PATCH] asus-laptop: add Lenovo SL LenovoCare LED 
	support
From: Corentin Chary <corentin.chary@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Alexandre Rostovtsev <tetromino@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 7:53 AM, Ike Panhc <ike.pan@canonical.com> wrote:
> Corentin Chary wrote:
>> On Tue, Dec 8, 2009 at 4:41 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>> On Tue, Dec 08, 2009 at 03:37:09PM +0800, Ike Panhc wrote:
>>>
>>>>  ASUS_HANDLE(rled_set, ASUS_HOTK_PREFIX "RLED");      /* W1JC */
>>>>  ASUS_HANDLE(pled_set, ASUS_HOTK_PREFIX "PLED");      /* A7J */
>>>>  ASUS_HANDLE(gled_set, ASUS_HOTK_PREFIX "GLED");      /* G1, G2 (probably) */
>>> The driver is controlling the ATKD device, which has a HID of ATK0101.
>>> These devices are all underneath it...
>>>
>>>> +ASUS_HANDLE(lled_set, "\\_SB_.PCI0.SBRG.EC0_.HKEY.TVLS"); /* LenovoCare */
>>> And this one isn't, which is a bit jarring. Looking closer, it's under
>>> the LEN0014 device, which means that you're trying to touch a method
>>> that belongs to a device other than the one this driver is bound to.
>>> That's wrong. You want a separate ACPI driver for the LEN0014 device,
>>> and this should be called for there. Looking at it, you seem to get
>>> rfkill as well (the GWAN/SWAN, GBDC/SBDF and GUWB/SUWB methods) and
>>> maybe some other stuff.
>>>
>>> So this shouldn't go in asus-laptop. You'll need to add another separate
>>> driver for the SL-specific functionality.
>>
>> That means asus-laptop and sl-laptop will be both needed for a SL
>> laptop, but I don't think this is a problem.
>>
> I think your suggestion is that one acpi driver for one acpi device.
> It makes sense to me. I will build a new driver.
>
>

You should take a look at the new eeepc-laptop driver in
http://git.iksaif.net/?p=acpi4asus.git;a=summary
Alan Jenkins cleaned it a lot so it can be an example for new drivers :)

-- 
Corentin Chary
http://xf.iksaif.net
