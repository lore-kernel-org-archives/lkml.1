Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZETI21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZETI21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZETI2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:28:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:24286 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZETI2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c/vmBL6jU3t5NhVtAoAUI4mpcaRpswLdOjkRZsd5Ti9hvKLmdUkXZy5XbF6yQtFCrs
         +WLQWSOp+smOdE9e8nTTbFpkN+zDg/908/EpDUIMVPRfHFOjobs1nZbAG7r67mGjsPGg
         BNltLkoiXdCC0UrKsD3xh1HK8xNxpl1W9wQGk=
MIME-Version: 1.0
In-Reply-To: <4A13BCE1.7050209@kernel.org>
References: <1242805059-18338-1-git-send-email-tj@kernel.org>
	 <1242805059-18338-3-git-send-email-tj@kernel.org>
	 <8bd0f97a0905200059pea3469do9e9b1a7644517558@mail.gmail.com>
	 <4A13B9EA.4030801@kernel.org> <4A13BCE1.7050209@kernel.org>
Date: Wed, 20 May 2009 04:28:18 -0400
Message-ID: <8bd0f97a0905200128k1f88276buc1738af4b4332f1e@mail.gmail.com>
Subject: Re: [PATCH 2/7] linker script: throw away .discard section
From: Mike Frysinger <vapier.adi@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 04:18, Tejun Heo wrote:
> Tejun Heo wrote:
>> Mike Frysinger wrote:
>>> On Wed, May 20, 2009 at 03:37, Tejun Heo wrote:
>>>> x86 throws away .discard section but no other archs do.  Also,
>>>> .discard is not thrown away while linking modules.  Make every arch
>>>> and module linking throw it away.  This will be used to define dummy
>>>> variables for percpu declarations and definitions.
>>> seems like a good time to introduce a common DISCARD define to
>>> include/asm-generic/vmlinux.lds.h.  considering multiple /DISCARD/
>>> entries are allowed in a linker script, the define should be pretty
>>> straightforward:
>>> #define DISCARDS \
>>>     /DISCARD/ : { \
>>>         EXIT_TEXT \
>>>         EXIT_DATA \
>>>         *(.exitcall.exit) \
>>>         *(.discard) \
>>>     }
>>
>> Hmmm... indeed, that would be nice.  I'll update the patch.
>
> Eh... handling of EXIT_TEXT and DATA aren't uniform across archs.  I
> think I'll leave the /DISCARD/ unification for the next time.

right, i think that's a bug where people simply forgot to declare
them.  if you stick DISCARDS at the end (and only replace when an arch
already has it at the end), there should be no change in behavior.
-mike
