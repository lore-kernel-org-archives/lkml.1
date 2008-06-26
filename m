Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbYFZTpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbYFZTpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763364AbYFZTn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:43:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:51984 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763352AbYFZTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MSZdFZW965z6ISt6a7Aqzit8sSyNlH0m8WgdkA34f1Eyc6MIduQzLCNOBdz2lO+YR3
         P3DFW20X83QfbXCHMJhjzvdfGMr55expW0xnyeICQwF5voEgfpMtYBqB6Mc3pDE+CZLH
         Azq+JdQ48qqjpy16ln+N1cqEp015juW5weCnA=
Message-ID: <2c0942db0806261243g52edd45eo11ded19bb1f24004@mail.gmail.com>
Date: Thu, 26 Jun 2008 12:43:20 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: monstr@seznam.cz
Subject: Re: [PATCH 08/60] microblaze_v4: exception handling
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       "Michal Simek" <monstr@monstr.eu>
In-Reply-To: <4863EBD9.1010601@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
	 <2c0942db0806260935p51564a7et6517b39e9a6706dc@mail.gmail.com>
	 <4863EBD9.1010601@seznam.cz>
X-Google-Sender-Auth: 470b5d360081e749
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 12:19 PM, Michal Simek <monstr@seznam.cz> wrote:
>> On Thu, Jun 26, 2008 at 5:29 AM,  <monstr@seznam.cz> wrote:
>>> +ex_sw:
>>> +       /* Get the destination register number into r5 */
>>> +       lbui    r5, r0, ex_reg_op;
>>> +       /* Form store_word jump table offset (sw_table + (8 * regnum)) */
>>> +       la      r6, r0, sw_table;
>>> +       add     r5, r5, r5;
>>> +       add     r5, r5, r5;
>>> +       add     r5, r5, r5;
>>> +       add     r5, r5, r6;
>>> +       bra     r5;
>>
>> Possibly stupid question: This is part of the unaligned store word
>> exception handler, yes? Shouldn't the above add's be addk's to
>> preserve the state of the carry register pre/post store?
>
> I don't think that addk is important. I have some tests for exception, I want to
> cover full exception handling.

Okay. It doesn't match your other exception handlers, though, which is
why I noticed it in the first place (they use addk).
