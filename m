Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYF2Hc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYF2Hc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 03:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYF2Hcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 03:32:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:51204 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYF2Hcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 03:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=GlBpHSzACTzrrTetIY1prS4jfADCReh00OX70Xv61JgMc2Vx+FIBH0n/nexhzRR12x
         GPmfGkd8lf0f9CoyXsVwv+PxmE788nsv8oYxEFjjUYw5alxXAjPh9SquQ3ndgIgEzCzF
         AerHmxba5SL8QtH5/0EDnZdrIMfMnuqx7gPYI=
Message-ID: <48673A9B.8050907@panasas.com>
Date: Sun, 29 Jun 2008 10:32:43 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix extern inline errors with gcc 4.3.0
References: <1214488251-20927-1-git-send-email-bhalevy@panasas.com> <20080627162645.GC8381@c2.user-mode-linux.org> <7225594ED4A1304C9E43D030A886D221050BE1@daytona.int.panasas.com>
In-Reply-To: <7225594ED4A1304C9E43D030A886D221050BE1@daytona.int.panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun. 28, 2008, 16:10 +0300, "Halevy, Benny" <bhalevy@panasas.com> wrote:
> On Fri 2008-06-27 19:26, Jeff Dike <jdike@addtoit.com> wrote:
>> On Thu, Jun 26, 2008 at 04:50:51PM +0300, Benny Halevy wrote:
>>> -KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
>>> +# Disable unit-at-a-time mode on pre-gcc-4.3 compilers, it makes gcc use
>>> +# a lot more stack due to the lack of sharing of stacklots:
>>> +# gcc 4.3.0 needs -funit-at-a-time for extern inline functions
>>> +KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0403 ] ; then \
>>> +			echo $(call cc-option,-fno-unit-at-a-time); fi ;)
>> How do we know that this patch won't cause the same crash reported in
>> http://marc.info/?l=linux-kernel&m=121011722806093&w=2?

Note that the crash happened with gcc 4.1.2 and it will get the
-fno-unit-at-a-time flag with the proposed patch.

That said, this option or the lack of it ought not to cause any
runtime crashes.  If it does, I'd feel much more comfortable to know
exactly what the root cause is before deciding to use the flag to
workaround^hide it.

Benny

> 
> I don't know what was the root cause for the crash you mentioned.
> FWIW, with these options UML/x86_64 builds on Fedora 9, w/ gcc 4.3.0
> and runs well for me.
> 
> Benny
> 
>> 				Jeff
>>
>> -- 
>> Work email - jdike at linux dot intel dot com
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

