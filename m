Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYKKXyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYKKXyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYKKXyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:54:10 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:63306 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYKKXyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:54:08 -0500
Date: Tue, 11 Nov 2008 15:42:09 -0800 (PST)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Andrew Morton <akpm@linux-foundation.org>
cc: djwong@us.ibm.com, Jean Delvare <khali@linux-fr.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do
 division with rounding
In-Reply-To: <20081111152007.ff508e26.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0811111539480.24267@t2.domain.actdsltmp>
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811111459300.24267@t2.domain.actdsltmp>
 <20081111152007.ff508e26.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Andrew Morton wrote:
> On Tue, 11 Nov 2008 15:05:02 -0800 (PST)
> Trent Piepho <tpiepho@freescale.com> wrote:
>> On Mon, 10 Nov 2008, Darrick J. Wong wrote:
>>> #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>>> #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>>> #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
>>> +#define DIV_ROUND_CLOSEST(x, divisor)(			\
>>> +{							\
>>> +	typeof(divisor) __divisor = divisor;		\
>>> +	(((x) + ((__divisor) / 2)) / (__divisor));	\
>>> +}							\
>>> +)
>>
>> Maybe you can do away with the statement-expression extension?  I've seen
>> cases where it cases gcc to generate worse code.  It seems like it
>> shouldn't, but it does.  I know DIV_ROUND_CLOSEST (maybe DIV_ROUND_NEAR?)
>> uses divisor twice, but all the also divide macros do that too, so why does
>> this one need to be different?
>
> The others need fixing too.

Is it worth generating worse code for these simple macros?

>> Note that if divisor is a signed variable, divisor/2 generates worse code
>> than divisor>>1.
>
> yup.  I wonder why the compiler doesn't do that for itself - is there a
> case where it will generate a different result?

main()
{
     int x = -5;
     printf("%d %d\n", x>>1, x/2);
}
$ a.out
-3 -2
