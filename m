Return-Path: <linux-kernel-owner+w=401wt.eu-S1030634AbXDWMm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634AbXDWMm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 08:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030678AbXDWMm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 08:42:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:57797 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030634AbXDWMm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 08:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DPePgwfZp3VjR5J1SQvW8GXCgoUXZT7LeH5C/him3rKgfXTbdSGBZG+oTHi4gzmS0AMjONAyIhCijCeBPldQQdj0jZ8IfJqGxBaAGR8cMoMVvydFvfXa5EbF4fzB7HJR4KfK+IZJi/W1aQTT+Oq1g0qY4JoMe4FNesf7iucfz9E=
Message-ID: <462CA9CB.7050006@gmail.com>
Date: Mon, 23 Apr 2007 14:42:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: pwarudkar@aol.com
CC: Jiri Kosina <jikos@jikos.cz>, Andrew Morton <akpm@linux-foundation.org>,
       dsk6@pitt.edu, linux-kernel@vger.kernel.org
Subject: Re: Sleep during spinlock in TPM driver
References: <alpine.DEB.0.82.0704221505370.14039@paragw-desktop> <Pine.LNX.4.64.0704230941390.20657@twin.jikos.cz> <alpine.DEB.0.82.0704230801230.6240@paragw-desktop>
In-Reply-To: <alpine.DEB.0.82.0704230801230.6240@paragw-desktop>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar napsal(a):
> On Mon, 23 Apr 2007, Jiri Kosina wrote:
> 
>> On Sun, 22 Apr 2007, Parag Warudkar wrote:
>>
>>> @@ -1097,8 +1097,13 @@
>>>
>>>       /* Driver specific per-device data */
>>>       chip = kzalloc(sizeof(*chip), GFP_KERNEL);
>>> - if (chip == NULL)
>>> + devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
>>> + +   if (chip == NULL || devname == NULL) {
>>
>> Hi,
>>
>> this line looks bogus to me.
>>
> 
> Hi - Yep, thanks for catching. Really not sure how that extra + got in
> there - I diffed the exact same file this morning and it isn't there -
> new diff attached.
[...]
> @@ -1097,8 +1097,13 @@
> 
>      /* Driver specific per-device data */
>      chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> -    if (chip == NULL)
> +    devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
> + +    if (chip == NULL || devname == NULL) {

I see this here too, but there is no extra '+' here:
http://lkml.org/lkml/2007/4/22/172 and here
http://lkml.org/lkml/2007/4/23/125
not even in the source of this message, weird... (using thunderbird 2.0rc1)

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
