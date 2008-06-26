Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbYFZVFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbYFZVFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYFZVFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:05:16 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:57110 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYFZVFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:05:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=UUgXDSj8DSNDfDen7q/ISKWmfu+PYmbr36joz7Ec0QVUtjnABh4mgz6G7pB2ms6Ol
	LhSGbAgTYnexXvPad40lA2P7UP5LOg8/iSZT4vx/fHXnjH3TtZu65wsurlkjC9JGoHL
	IqGj0CeMmH3zBDNWMrGn7TvUQ6EnBwOEvPcZf4I=
Message-ID: <486404C3.10301@seznam.cz>
Date: Thu, 26 Jun 2008 23:06:11 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com
Subject: Re: [PATCH 08/60] microblaze_v4: exception handling
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>	 <1214483429-32360-3-git-send-email-monstr@seznam.cz>	 <1214483429-32360-4-git-send-email-monstr@seznam.cz>	 <1214483429-32360-5-git-send-email-monstr@seznam.cz>	 <1214483429-32360-6-git-send-email-monstr@seznam.cz>	 <1214483429-32360-7-git-send-email-monstr@seznam.cz>	 <1214483429-32360-8-git-send-email-monstr@seznam.cz>	 <1214483429-32360-9-git-send-email-monstr@seznam.cz>	 <2c0942db0806260935p51564a7et6517b39e9a6706dc@mail.gmail.com>	 <4863EBD9.1010601@seznam.cz> <2c0942db0806261243g52edd45eo11ded19bb1f24004@mail.gmail.com>
In-Reply-To: <2c0942db0806261243g52edd45eo11ded19bb1f24004@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm4<127342598>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee napsal(a):
> On Thu, Jun 26, 2008 at 12:19 PM, Michal Simek <monstr@seznam.cz> wrote:
>>> On Thu, Jun 26, 2008 at 5:29 AM,  <monstr@seznam.cz> wrote:
>>>> +ex_sw:
>>>> +       /* Get the destination register number into r5 */
>>>> +       lbui    r5, r0, ex_reg_op;
>>>> +       /* Form store_word jump table offset (sw_table + (8 * regnum)) */
>>>> +       la      r6, r0, sw_table;
>>>> +       add     r5, r5, r5;
>>>> +       add     r5, r5, r5;
>>>> +       add     r5, r5, r5;
>>>> +       add     r5, r5, r6;
>>>> +       bra     r5;
>>> Possibly stupid question: This is part of the unaligned store word
>>> exception handler, yes? Shouldn't the above add's be addk's to
>>> preserve the state of the carry register pre/post store?
>> I don't think that addk is important. I have some tests for exception, I want to
>> cover full exception handling.
> 
> Okay. It doesn't match your other exception handlers, though, which is
> why I noticed it in the first place (they use addk).

thanks for notice. I'll keep in my mind when I test it.

M


