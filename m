Return-Path: <linux-kernel-owner+w=401wt.eu-S1761318AbYCZSeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbYCZSeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbYCZSeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:34:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:36349 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbYCZSeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Aqg/edkVS7L1kEgJhgjRf/TpWH9R0njrf1AzRqbsg9Ohqam8NP6giPrb5dahpzNH9pAoc0f0yu+HubRB5vTDkcRTiuZ0ORpp7PAb0RsNUjGmWq+fSD5OHt0HLvdw6amEkxDEETlnSoo9LYt4OnVnZvG4/cN8/yF4/oNC6ksfJrA=
Message-ID: <47EA971B.1020502@gmail.com>
Date: Wed, 26 Mar 2008 19:34:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/1] [Blackfin try #2] char driver for Blackfin on-chip
 OTP memory
References: <1206580131-22527-1-git-send-email-cooloney@kernel.org>	 <47EA268F.8070006@gmail.com> <8bd0f97a0803260731x4378c71q1e2e5598c1728e1d@mail.gmail.com>
In-Reply-To: <8bd0f97a0803260731x4378c71q1e2e5598c1728e1d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2008 03:31 PM, Mike Frysinger wrote:
> On Wed, Mar 26, 2008 at 6:33 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 03/27/2008 02:08 AM, Bryan Wu wrote:
>>  > From: Mike Frysinger <vapier.adi@gmail.com>
>>> +static int __init bfin_otp_init(void)
>>  > +{
>>  > +     int ret;
>>  > +
>>  > +     stampit();
>>  > +
>>  > +     ret = misc_register(&bfin_otp_misc_device);
>>  > +     if (ret) {
>>  > +             pr_init(KERN_ERR PFX "unable to register a misc device\n");
>>  > +             return ret;
>>  > +     }
>>  > +
>>  > +     pr_init(KERN_INFO PFX "initialized\n");
>>
>>  except the fact, that pr_init definition seems to be broken. Its defined __fmt
>>  is const, so it should reside in .init.rodata (__initconst), not .init.data
>>  (__initdata).
> 
> i dont see an __initconst macro anywhere ?

It's in include/linux/init.h as of 2.6.25-rc2.

> also, it isnt "broken" in the sense that it "doesnt work" ;)

Gcc simply doesn't allow that, you likely got 2 sections with init.data, with 
and without readonly bit set, which is wrong, and it seems, that on some systems 
(debian) you won't even compile it.
