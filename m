Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZG0UE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZG0UE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZG0UE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:04:26 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:46975 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbZG0UEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XdPaRKohVfW2w6DYndKAAFGgkRTvi36pMdkj/Qaz7E9trqDrCR1TcG4+4MAbS3Y50h
         IVV2dZkqtJkmaFVRgHW+zjaxF/rVtQ8DTYu8m2RiQyqdmY/L2THmFnUnTijofRSc2H2T
         +8XXtDg0/0LjM5RrdH6u2cCBh5b+4eODsBTqA=
MIME-Version: 1.0
In-Reply-To: <84144f020907271245q1d635e49j15a32c85303bf073@mail.gmail.com>
References: <20090727192720.GA30366@bit.office.eurotux.com>
	 <84144f020907271245q1d635e49j15a32c85303bf073@mail.gmail.com>
Date: Mon, 27 Jul 2009 21:04:23 +0100
Message-ID: <9b2b86520907271304i3709d1e0s1cf43c6e9f48f794@mail.gmail.com>
Subject: Re: eeepc_hotkey adds 25s to boot
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Luciano Rocha <luciano@eurotux.com>
Cc: linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/09, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> (Adding Corentin to cc)
>
> On Mon, Jul 27, 2009 at 10:27 PM, Luciano Rocha<luciano@eurotux.com> wrote:
>> As subject says, loading the eeepc_hotkeys driver or including it inside
>> the kernel adds 25s to the boot process:
>> [   13.990092] eeepc: Eee PC Hotkey Driver
>> [   39.560645] eeepc: Hotkey init flags 0x41
>> [   39.566131] eeepc: Get control methods supported: 0x101713
>> [   39.566418] input: Asus EeePC extra buttons as ...
>>
>> Kernel is 2.6.30.3 (with tuxonice).

Sounds like <http://bugzilla.kernel.org/show_bug.cgi?id=13620>.  If
I'm right, it will go away if you blacklist the i2c_i801 module.  E.g.

echo "blacklist i2c_i801" >> /etc/modprobe.d/blacklist.conf

>> Config and full dmesg follows.
>>
>> Also, a "rmmod eeepc_hotkeys" resulted in a kernel panic. If asked, I'll
>> try to replicate it.
>
> Yes, please.
