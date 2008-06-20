Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYFTLNC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYFTLNC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYFTLMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:12:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:7679 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbYFTLMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DiXE8W8o/IQp4D5gOOwsgxAkMUsOcI8ng432DT7bEbP3DRGJCEDDBGJCPNh40j4w1M
         a5TDkvqi+jh1BLXHaft1xSgHqB4u2C7XyQgymfG/itPgBdrfQLt8ik2QKirpL7YQe6um
         zMjml0w1YuU9nkMgL+VebJgVq9VcXTM1y8Pes=
Message-ID: <84144f020806200412s5e0225eblbb2001ca139e7fdc@mail.gmail.com>
Date: Fri, 20 Jun 2008 14:12:51 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Savchenko" <Bircoph@list.ru>
Subject: Re: [RFC/PATCH] ipg: add jumbo frame support kconfig option
Cc: linux-kernel@vger.kernel.org, "Francois Romieu" <romieu@fr.zoreil.com>,
       "Linux Netdev List" <netdev@vger.kernel.org>, shemminger@vyatta.com,
       "Jeff Garzik" <jeff@garzik.org>, sorbica@icplus.com.tw,
       "Jesse Huang" <jesse@icplus.com.tw>
In-Reply-To: <200806201037.46687.Bircoph@list.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806201037.46687.Bircoph@list.ru>
X-Google-Sender-Auth: 84465840ef265d5d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

(Please don't trim the cc.)

On Fri, Jun 20, 2008 at 9:37 AM, Andrew Savchenko <Bircoph@list.ru> wrote:
> Hello,
>
> On Wed, 27 Feb 2008 09:44:44 +0200 (EET), Pekka J Enberg wrote:
>> Stephen Hemminger wrote:
>> > > Please don't do this as a config option. Config options seem
>> > > like a good idea to developers but are difficult for
>> > > distributions.  Either support jumbo frames by default or
>> > > not at all.
>>
>> On Tue, 26 Feb 2008, Jeff Garzik wrote:
>> > Agreed, but to be more specific... always compile in jumbo
>> > frame support. You don't have to enable it at runtime by
>> > default, though.
>>
>> Ok, so a sysfs attribute would be sufficient, I suppose? I don't
>> have the hardware though, so I don't even know if the jumbo
>> frame code actually works at this point hence the RFC. So I'll
>> wait for someone to test this before sending a new patch. Thanks
>> for the review!
>
> I own such card:
> 02:02.0 Ethernet controller: Sundance Technology Inc / IC Plus Corp
> IP1000 Family Gigabit Ethernet (rev 41)
> and I use patch similar to yours in order to enable Jumbo Frames.
> See attachment for details, patch is done for linux-2.6.25.6.
>
> It works fine for me. However, I enabled 10K jumbo boxes instead of
> default 4K value, activated using your patch. Reason is simple: I
> need at least 9000-byte jumbo boxes in my network.
>
> However, I have one request for you: please, make in possible to
> choose max MTU via kernel config option. In different environments
> different people may need different max MTU sizes (2K...10K).
> Recommended value is 4K (as described in the original driver from
> manufacturer, which was remake into kernel's one), but, for
> example, I'm interested in larger MTU values. OTOH larger MTU
> values require more memory and so on. For me, as for end user of
> Linux kernel, a possibility to select desired max MTU is very
> attractive and is definitely in no doubt more convenient than
> patching the kernel myself each time.
>
> So, feel free to add jumbo boxes on ipg support to the mainstream
> and, please, make in possible to select max MTU; 4K as default
> will be fine.

As I don't have the hardware, I would appreciate if you could test
the following quilt tree:

  http://www.kernel.org/pub/linux/kernel/people/penberg/patches/ipg/2.6.26-rc6/

[Note: in case you're not familiar with quilt, the patches need to
 be applied in the order specified by the quilt 'series' file
 included there.]

You can enable 10KB jumbo frames either by passing:

  ipg.jumbo=10k

to the kernel command line or, alternatively, load the ipg module
as follows:

  modprobe ipg jumbo=10k

You cannot enable or disable jumbo frame support once the module
is loaded so if you want to try out different frame sizes, you
first need to unload the module.

                           Pekka
