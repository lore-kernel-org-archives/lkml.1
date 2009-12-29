Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZL2UVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZL2UVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZL2UVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:21:00 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44101 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZL2UU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:20:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XvYFlTDblu12v/6iwQRbGTepk1CD2dLUA6l+e2l7h4wNh4SQisf0+F+AzuoGGvQhrx
         2Rxt8p9te7Puy68nap9vWhwUABF3bcQTSC5M5BFTr3RxcFlteM2+9hvPQq1sjxlLnCyq
         WCCrPzR0lqctVyj+hQAqvPgtVIiDgj7coleEo=
Message-ID: <4B3A64A8.5040104@garzik.org>
Date: Tue, 29 Dec 2009 15:20:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the purpose of MAXHOSTNAMELEN?
References: <alpine.LFD.2.00.0912291416230.4967@localhost> <4B3A5B15.5060807@garzik.org> <20091229195608.GG4815@const>
In-Reply-To: <20091229195608.GG4815@const>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2009 02:56 PM, Samuel Thibault wrote:
> Jeff Garzik, le Tue 29 Dec 2009 14:40:05 -0500, a écrit :
>> On 12/29/2009 02:19 PM, Robert P. J. Day wrote:
>>> arch/s390/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max
>>> length of hostname */
>>>
>>>    so lots of people define it but no one uses it.  it *is* exported to
>>> user space in /usr/include/asm/param.h, but i still have no idea what
>>> it's for in user space.  obsolete?
>>
>> According to RFC 1034, "Each node has a label, which is zero to 63
>> octets in length"
>
> That's for Internet networks.  Other kinds of networks could implement
> more.  It could make sense to restrict ourself to Internet standards,
> but we don't :)

Er huh?  That was a description of the origin of the limit.

And as a point of fact, we do restrict ourself to that:

	#define __NEW_UTS_LEN 64

	struct new_utsname {
	        char sysname[__NEW_UTS_LEN + 1];
	        char nodename[__NEW_UTS_LEN + 1];



>> What is it used for in userspace, and why is it export from the kernel?
>
> Gethostname, typically, but also all kinds of functions that provide a
> hostname.  It's also quite often completely badly used, for instance for
> getnameinfo()...
>
> You have Debian's list on
> http://unstable.buildd.net/buildd/hurd-i386_Failed.html

No one cares about Hurd.

	Jeff




