Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYBREGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYBREGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 23:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYBREGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 23:06:23 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:63575 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbYBREGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 23:06:23 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/bwsLadTnPak8QSB6qyBn4
Message-ID: <47B90417.2010406@reed.com>
Date: Sun, 17 Feb 2008 23:05:43 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-kernel] Re: [PATCH 1/3] x86: fix init_8259A() to not use
 outb_pic
References: <6gr00g$g7cm8h@smtp01.lnh.mail.rcn.net> <20080217222552.1af463b4@core> <47B8EDDA.4080801@keyaccess.nl>
In-Reply-To: <47B8EDDA.4080801@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 17-02-08 23:25, Alan Cox wrote:
>
>> On Sun, 17 Feb 2008 16:56:28 -0500 (EST)
>> "David P. Reed" <dpreed@reed.com> wrote:
>>
>>> fix init_8259A() which initializes the 8259 PIC to not use outb_pic,
>>> which is a renamed version of outb_p, and delete outb_pic define.
>>
>> NAK
>>
>> The entire point of inb_pic/outb_pic is to isolate the various methods
>> and keep the logic for delays in one place. Undoing this just creates a
>> nasty mess.
>>
>> Quite probably inb_pic/outb_pic will end up as static inlines that do 
>> inb
>> or outb with a udelay of 1 or 2 but that is where the knowledge belongs.
>
> Additional NAK in sofar that the PIC delays were reported to be 
> necesary with some VIA chipsets earlier in these threads.
>
> Rene.
>
This not being a place where performance matters, I will submit a new 
patch that changes inb_pic and outb_pic to use udelay(2).  However, note 
that init_8259A does not use these consistently in its own accesses to 
the PIC registers.  Should I change it to use the _pic calls whereever 
it touches the PIC registers to be conservative?  Note that there is a 
udelay(100) after the registers are all setup, perhaps this is the real 
VIA requirement...
