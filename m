Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYFZTTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYFZTTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYFZTTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:19:14 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:60965 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbYFZTTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:19:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=EsIQD+iC3vm7OBnXZqSqEByYExlXkd+ofMq1azgu2VzOFqLslmbY+gzrCULynZ+qo
	lrt44MYwa/uaCVjaHJq0paFBpN7yWI2VxXZvAatiwfVc2LnZ0cj70C+rSpdYMKLjZqb
	9WxsRGkNAac4iFlBzsGnBTXx+TA4LKX7voWjBKg=
Message-ID: <4863EBD9.1010601@seznam.cz>
Date: Thu, 26 Jun 2008 21:19:53 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 08/60] microblaze_v4: exception handling
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>	 <1214483429-32360-2-git-send-email-monstr@seznam.cz>	 <1214483429-32360-3-git-send-email-monstr@seznam.cz>	 <1214483429-32360-4-git-send-email-monstr@seznam.cz>	 <1214483429-32360-5-git-send-email-monstr@seznam.cz>	 <1214483429-32360-6-git-send-email-monstr@seznam.cz>	 <1214483429-32360-7-git-send-email-monstr@seznam.cz>	 <1214483429-32360-8-git-send-email-monstr@seznam.cz>	 <1214483429-32360-9-git-send-email-monstr@seznam.cz> <2c0942db0806260935p51564a7et6517b39e9a6706dc@mail.gmail.com>
In-Reply-To: <2c0942db0806260935p51564a7et6517b39e9a6706dc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm1<165082998>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> On Thu, Jun 26, 2008 at 5:29 AM,  <monstr@seznam.cz> wrote:
>> +ex_sw:
>> +       /* Get the destination register number into r5 */
>> +       lbui    r5, r0, ex_reg_op;
>> +       /* Form store_word jump table offset (sw_table + (8 * regnum)) */
>> +       la      r6, r0, sw_table;
>> +       add     r5, r5, r5;
>> +       add     r5, r5, r5;
>> +       add     r5, r5, r5;
>> +       add     r5, r5, r6;
>> +       bra     r5;
> 
> Possibly stupid question: This is part of the unaligned store word
> exception handler, yes? Shouldn't the above add's be addk's to
> preserve the state of the carry register pre/post store?

I don't think that addk is important. I have some tests for exception, I want to
cover full exception handling.

M

