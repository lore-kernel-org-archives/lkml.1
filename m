Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZKOSoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZKOSoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 13:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZKOSob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 13:44:31 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:40028 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751832AbZKOSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 13:44:31 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 32zBtqEVM1lIoQ7NJ_pXFktN1i27bkDDWmeX4KfPaRCIK_1TJBlfpC2yz1yHReuT1e.cL.6Mi9RGdNXtJ18FptjL4JMklMaM0Qsb15Kps6xOzVt5fAiXaxljKh6I7epXxv0JdBFwv_YU4XKb1OAVsVGoduVyqBZnjAoA0dcFByfcBIYq1TxpJwftENAfiEyrIkvlA.QXhWHes0RlNLb4pm8luATP.tFHIRVgcL6T7simR5FoUaHBBLm91gK7HRT4.w5iJqoqsIf4RVZQQOAzADV7_jwPRC9oOFStbeVJ2r5KG8Ia53CscIBVpoyOA5NIMlgmoEM2tw3W8E6v.p2l
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B004C11.8020609@schaufler-ca.com>
Date: Sun, 15 Nov 2009 10:44:33 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Raja R Harinath <harinath@hurrynot.org>
CC: linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>	<4AFCC06B.1030302@schaufler-ca.com>	<19857.1258147396@turing-police.cc.vt.edu>	<4AFE1EA9.60102@schaufler-ca.com>	<hdl92e$srv$1@taverner.cs.berkeley.edu>	<1258170491.16857.142.camel@Joe-Laptop.home>	<4AFE3C53.70709@schaufler-ca.com>	<1258176381.16857.155.camel@Joe-Laptop.home>	<4AFE5A20.20608@schaufler-ca.com> <87y6m8s03l.fsf@hariville.hurrynot.org>
In-Reply-To: <87y6m8s03l.fsf@hariville.hurrynot.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raja R Harinath wrote:
> Hi,
>
> Casey Schaufler <casey@schaufler-ca.com> writes:
>
>   
>> Joe Perches wrote:
>>     
> [snip]
>   
>>> I assert that code should be made as readable
>>> as possible and that the code used fit the
>>> reader's expectations.
>>>
>>> strcmp(foo, "BAR") is natural.
>>> strncmp(foo, "BAR", sizeof("BAR")) is unnatural
>>> and should not be used.
>>>       
>> Oh good gravy. I've been writing C code since the 1970's and
>> have seen enough "unnatural" code to make most people think that
>> PASCAL was a good idea. This is not unnatural code. This is an
>> argument over which side of the head of the pin the odd angel
>> should dance on. Give it up. You're advocating a gratuitous
>> change. Can't y'all go find some questionable casts to expunge?
>> That might actually be useful.
>>     
>
> I think the point is that
>
>     strncmp(foo, "BAR", sizeof("BAR"))
>
> is exceedingly similar to
>
>     strncmp(foo, "BAR", strlen("BAR"))
>
> which mean different things.  The point of this series was the suspicion
> that people who intended the "strlen" variant might have used the
> "sizeof" variant.
>   

The point is that the code is correct as written. The change
suggested, changing the sizeof to strlen, would result in
incorrect behavior in the case where foo is "BAR-BAR-BA-RAN".
The other change suggested, which is to change strncmp to
strcmp, would be functionally correct but offers no value,
might be considered less safe in certain circles, and requires
a change that, like any change, adds a trivial amount of risk.

> And, since this confusion exists, it is probably better to use two
> canonical forms for the two different meanings
>
>    strcmp(foo, "BAR")
>    strncmp(foo, "BAR", strlen("BAR"))
>
> and avoid other equivalent formulations.
>
> - Hari
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

