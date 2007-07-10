Return-Path: <linux-kernel-owner+w=401wt.eu-S1764602AbXGJSh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764602AbXGJSh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXGJShL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:37:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764496AbXGJShF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:37:05 -0400
Message-ID: <4693D1C9.8090607@zytor.com>
Date: Tue, 10 Jul 2007 11:36:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 17/33] A20 handling code
References: <11840359321823-git-send-email-hpa@zytor.com> <11840360383913-git-send-email-hpa@zytor.com> <11840361432207-git-send-email-hpa@zytor.com> <11840362483663-git-send-email-hpa@zytor.com> <11840363531039-git-send-email-hpa@zytor.com> <11840364593068-git-send-email-hpa@zytor.com> <1184036564610-git-send-email-hpa@zytor.com> <11840366692770-git-send-email-hpa@zytor.com> <11840367741994-git-send-email-hpa@zytor.com> <11840368791603-git-send-email-hpa@zytor.com> <11840369841576-git-send-email-hpa@zytor.com> <11840370903975-git-send-email-hpa@zytor.com> <11840371953778-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <11840374052662-git-send-email-hpa@zytor.com> <1184037510289-git-send-email-hpa@zytor.com> <11840376162370-git-send-email-hpa@zytor.com> <11840377211519-git-send-email-hpa@zytor.com> <Pine.LNX.4.64.0707102025390.11053@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707102025390.11053@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>> +
>> +#define A20_TEST_ADDR	(4*0x80)
>> +#define A20_TEST_SHORT  32
>> +#define A20_TEST_LONG	2097152	/* 2^21 */
> 
> Maybe...?
> #define A20_TEST_LONG (1 << 21)

That makes it look like it's a magic value or bitmask, it's not.  The
value 2^21 is largely arbitrary, it's just what happened to be in the
previous code.

>> +/* Quick test to see if A20 is already enabled */
>> +static int a20_test_short(void)
>> +{
>> +	return a20_test(A20_TEST_SHORT);
>> +}
>> +
>> +/* Longer test that actually waits for A20 to come on line; this
>> +   is useful when dealing with the KBC or other slow external circuitry. */
>> +static int a20_test_long(void)
>> +{
>> +	return a20_test(A20_TEST_LONG);
>> +}
> 
> To me looks like some of these (or other functions) could return bool.

Does it matter?  It will generate worse code.

	-hpa
