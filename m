Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZDFXxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZDFXxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZDFXxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:53:06 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:63317 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZDFXxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CFMWf2UvttMcWEud4PGeZ9yuFbRYHRmk+oqj4pLYSxfdkd5qgVaMJVEd/1C39WX1DI
         eihd/Ubxr7Nxop6Ikfwsid1SRnX6QeBBMfKUqHRmpPksA9kvZFnaXUioVfSH1RhT+4Or
         bd+bPIQCvbr119/2mV8SuTTjKj2jfAJJGiYSM=
Subject: [BISECTED] [REGRESSION] can't anymore even do a s2ram-s2disk-s2ram
 cycle on acer aspire 5720G
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 02:52:56 +0300
Message-Id: <1239061976.4705.16.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is first time, I am actually happy about a regression....

I have a notebook, aspire 5720G that fails to do two suspends to ram in
row.

for example I can do s2ram->s2disk->s2ram->...
but can't s2ram->s2ram.

Well that at least was the situation till now.
Also there is no way to debug this - bios doesn't pass control back to
linux on failed resume. I tried probably every guess I could come with.

Now, after a commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 which I
finally bisected, I can't anymore do two suspends to ram at all,
regardless of suspend to disk in between. Also bios doesn't pass control
when resume fails.

I actually did 3 bisects, as I had to find fixes to 2 more s2ram bugs
that were fixed.
the fixes are:

a0e280e0f33f6c859a235fb69a875ed8f3420388
1e70c7f7a9d4a3d2cc78b40e1d7768d99cd79899


Now, why I am happy about this:
It seems that a suspend cycle changes something that explodes on next
resume. a s2disk cycle cleared this, but not anymore, thus the poison
must be somehow connected to the
a0d4922da2e4ccb0973095d8d29f36f6b1b5f703

PCI state?? I tried restoring it from saved file, (created on suspend)
but this didn't help.
(Only a single register, which looks like a clear or write register
changed).


Also this commits narrows down the search, now it is clear that this is
usb related. No wonder bios pokes at usb on resume and stalls.....


It could even be connected to bios handoff, maybe we don't do that on
resume?

(Note: this regression is present all way to latest -git)


What do you think?

Best regards,
	Maxim Levitsky



