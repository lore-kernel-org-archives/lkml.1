Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYBRRa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYBRRa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYBRRar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:30:47 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:50132 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYBRRaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:30:46 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ESz/orPHIWhxAAvx8j9GD
Message-ID: <47B9C0A2.2060208@reed.com>
Date: Mon, 18 Feb 2008 12:30:10 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [linux-kernel] Re: [patch 1/2] x86: define outb_pic and inb_pic
 to stop using outb_p and inb_p
References: <6gr00g$g7mc5k@smtp01.lnh.mail.rcn.net> <20080218154546.66e4c72d@core>
In-Reply-To: <20080218154546.66e4c72d@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> +unsigned char inb_pic(unsigned int port)
>> +{
>> +	/* delay for some accesses to PIC on motherboard or in chipset must be
>> +	   at least one microsecond, but be safe here. */
>> +	unsigned char value = inb(port);
>> +	udelay(2);
>> +	return value;
>> +}
>>     
>
> inline it. Its almost no instructions
>
>   
Will do. Assume you desire inlining of the outb_pic, and also the 
inb_pit and outb_pit routines.  Didn't do it because the code is 
slightly bigger than the call.
