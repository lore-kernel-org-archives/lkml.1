Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXGJStO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXGJStO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbXGJSsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:48:45 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53043 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbXGJSsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:48:41 -0400
Message-ID: <4693D463.5010900@zytor.com>
Date: Tue, 10 Jul 2007 11:48:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 20/33] Console-writing code for the new x86 setup
 code
References: <11840359321823-git-send-email-hpa@zytor.com> <11840361432207-git-send-email-hpa@zytor.com> <11840362483663-git-send-email-hpa@zytor.com> <11840363531039-git-send-email-hpa@zytor.com> <11840364593068-git-send-email-hpa@zytor.com> <1184036564610-git-send-email-hpa@zytor.com> <11840366692770-git-send-email-hpa@zytor.com> <11840367741994-git-send-email-hpa@zytor.com> <11840368791603-git-send-email-hpa@zytor.com> <11840369841576-git-send-email-hpa@zytor.com> <11840370903975-git-send-email-hpa@zytor.com> <11840371953778-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <11840374052662-git-send-email-hpa@zytor.com> <1184037510289-git-send-email-hpa@zytor.com> <11840376162370-git-send-email-hpa@zytor.com> <11840377211519-git-send-email-hpa@zytor.com> <11840378261081-git-send-email-hpa@zytor.com> <11840379311574-git-send-email-hpa@zytor.com> <11840380363720-git-send-email-hpa@zytor.com> <Pine.LNX.4.64.0707102033060.11053@fbirervta.pbzchgretzou.q!
 r>
In-Reply-To: <Pine.LNX.4.64.0707102033060.11053@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 9 2007 19:51, H. Peter Anvin wrote:
>> +
>> +static inline int isdigit(int ch)
>> +{
>> +	return (ch >= '0') && (ch <= '9');
>> +}
> 
> I'd say static inline unsigned int isdigit(unsigned char), since ASCII does not
> realistically exceed 255.

If you're trying to be standard, you're doing the wrong thing (the
standard is int, since -1 is a permitted value.)

It doesn't matter anyway, and your version would probably generate
slightly worse code.

>> +static int strnlen(const char *s, int maxlen)
> 
> unsigned int,  and               unsigned int, too?
> The glibc strnlen type also uses unsigned types.

If anything it should be size_t.  Fixing, and moved to string.c, where
it belongs.

	-hpa
