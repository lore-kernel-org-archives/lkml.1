Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbXFMP7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbXFMP7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbXFMP64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:58:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:22960 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531AbXFMP6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H6MlZmZzV7sNGR6spJeccbv82I5J2tm0G0+ZX12p8UjEVGzc9zklkqc+6MsG5HFX7Xom1YYrpNQiOgDIgv6OiYlAC3PTSyOlHHmm6OqYjLqKBgWJ1fszZh7HZ8b5m/UB5in/N7dV6xfE7NkLfbTQTDtQXyJUdpapkH6MviJmgGU=
Subject: Re: USB remote control missing keycodes
From: Islam Amer <pharon@gmail.com>
Reply-To: pharon@gmail.com
To: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706131741420.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro>
	 <1181563063.19258.11.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
	 <1181743734.6163.1.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
	 <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com>
	 <Pine.LNX.4.64.0706131741420.23280@twin.jikos.cz>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 18:58:46 +0300
Message-Id: <1181750326.6163.6.camel@iamer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 17:44 +0200, Jiri Kosina wrote:
> On Wed, 13 Jun 2007, Dmitry Torokhov wrote:
> 
> > Actually this one does not need hidbus and can be easily handled from 
> > userspace now that we have setkeycodes support for HID.
> 
> Sure, thanks for reminding.
> 
> Islam, if you'd like to write an userspace 'driver' (really trivial 
> few-liner) for the missing keys, you can use a new functionality in recent 
> kernels, which allows you to use EVIOCSKEYCODE ioctl() on evdev to create 
> a proper mapping between the usage codes that are not handled by 
> hid-input, and keycodes.
> 

Interesting.. I assumed since evbug was not producing usable codes for
these keys then the evdev layer would not get any codes at all.

Starting from what version did this ioctl get added and is it documented
anywhere ?

Nevertheless the patch you sent got the "TXT" key to work but not the
"BACK" key. Here are the codes for all of the non-functioning keys
( TXT , BACK , 4 COLOR keys ):



RED button

[ 1076.800000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1076.800000] drivers/hid/hid-core.c: report 5 (size 4) =  5b 00 00 00
[ 1076.800000] hid-debug: input ffbc.0000 = 0
[ 1076.800000] hid-debug: input ffbc.005b = 1
[ 1076.808000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1076.808000] drivers/hid/hid-core.c: report 6 (size 4) =  01 2b 00 00
[ 1076.808000] hid-debug: input ff80.0001 = 1
[ 1076.808000] hid-debug: input ff80.0001 = 43
[ 1076.808000] hid-debug: input ff80.0001 = 0
[ 1076.808000] hid-debug: input ff80.0001 = 0
[ 1076.904000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1076.904000] drivers/hid/hid-core.c: report 6 (size 4) =  01 2b 00 00
[ 1076.904000] hid-debug: input ff80.0001 = 1
[ 1076.904000] hid-debug: input ff80.0001 = 43
[ 1076.904000] hid-debug: input ff80.0001 = 0
[ 1076.904000] hid-debug: input ff80.0001 = 0
[ 1077.024000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1077.024000] drivers/hid/hid-core.c: report 5 (size 4) =  00 00 00 00
[ 1077.024000] hid-debug: input ffbc.005b = 0
[ 1077.024000] hid-debug: input ffbc.0000 = 1

GREEN button

[ 1196.060000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1196.060000] drivers/hid/hid-core.c: report 5 (size 4) =  5c 00 00 00
[ 1196.060000] hid-debug: input ffbc.0000 = 0
[ 1196.060000] hid-debug: input ffbc.005c = 1
[ 1196.068000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1196.068000] drivers/hid/hid-core.c: report 6 (size 4) =  01 2c 00 00
[ 1196.068000] hid-debug: input ff80.0001 = 1
[ 1196.068000] hid-debug: input ff80.0001 = 44
[ 1196.068000] hid-debug: input ff80.0001 = 0
[ 1196.068000] hid-debug: input ff80.0001 = 0
[ 1196.164000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1196.164000] drivers/hid/hid-core.c: report 6 (size 4) =  01 2c 00 00
[ 1196.164000] hid-debug: input ff80.0001 = 1
[ 1196.164000] hid-debug: input ff80.0001 = 44
[ 1196.164000] hid-debug: input ff80.0001 = 0
[ 1196.164000] hid-debug: input ff80.0001 = 0
[ 1196.292000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1196.292000] drivers/hid/hid-core.c: report 5 (size 4) =  00 00 00 00
[ 1196.292000] hid-debug: input ffbc.005c = 0
[ 1196.292000] hid-debug: input ffbc.0000 = 1


YELLOW button

[ 1222.552000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1222.552000] drivers/hid/hid-core.c: report 5 (size 4) =  5d 00 00 00
[ 1222.552000] hid-debug: input ffbc.0000 = 0
[ 1222.552000] hid-debug: input ffbc.005d = 1
[ 1222.560000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1222.560000] drivers/hid/hid-core.c: report 6 (size 4) =  01 ad 00 00
[ 1222.560000] hid-debug: input ff80.0001 = 1
[ 1222.560000] hid-debug: input ff80.0001 = 173
[ 1222.560000] hid-debug: input ff80.0001 = 0
[ 1222.560000] hid-debug: input ff80.0001 = 0
[ 1222.656000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1222.656000] drivers/hid/hid-core.c: report 6 (size 4) =  01 ad 00 00
[ 1222.656000] hid-debug: input ff80.0001 = 1
[ 1222.656000] hid-debug: input ff80.0001 = 173
[ 1222.656000] hid-debug: input ff80.0001 = 0
[ 1222.656000] hid-debug: input ff80.0001 = 0
[ 1222.776000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1222.776000] drivers/hid/hid-core.c: report 5 (size 4) =  00 00 00 00
[ 1222.776000] hid-debug: input ffbc.005d = 0
[ 1222.776000] hid-debug: input ffbc.0000 = 1

BLUE button

[ 1472.908000] drivers/hid/hid-core.c: report 5 (size 4) =  5e 00 00 00
[ 1472.908000] hid-debug: input ffbc.0000 = 0
[ 1472.908000] hid-debug: input ffbc.005e = 1
[ 1472.916000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1472.916000] drivers/hid/hid-core.c: report 6 (size 4) =  01 ae 00 00
[ 1472.916000] hid-debug: input ff80.0001 = 1
[ 1472.916000] hid-debug: input ff80.0001 = 174
[ 1472.916000] hid-debug: input ff80.0001 = 0
[ 1472.916000] hid-debug: input ff80.0001 = 0
[ 1473.036000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1473.036000] drivers/hid/hid-core.c: report 5 (size 4) =  00 00 00 00
[ 1473.036000] hid-debug: input ffbc.005e = 0
[ 1473.036000] hid-debug: input ffbc.0000 = 1


BACK key

[ 1573.316000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1573.316000] drivers/hid/hid-core.c: report 4 (size 4) =  fa 00 00 00
[ 1573.316000] hid-debug: input Consumer.0000 = 0
[ 1573.324000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1573.324000] drivers/hid/hid-core.c: report 6 (size 4) =  01 23 00 00
[ 1573.324000] hid-debug: input ff80.0001 = 1
[ 1573.324000] hid-debug: input ff80.0001 = 35
[ 1573.324000] hid-debug: input ff80.0001 = 0
[ 1573.324000] hid-debug: input ff80.0001 = 0
[ 1573.436000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1573.436000] drivers/hid/hid-core.c: report 4 (size 4) =  00 00 00 00
[ 1573.436000] hid-debug: input Consumer.0000 = 1

TXT key

[ 1635.116000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1635.116000] drivers/hid/hid-core.c: report 5 (size 4) =  5a 00 00 00
[ 1635.116000] hid-debug: input ffbc.0000 = 0
[ 1635.116000] hid-debug: input ffbc.005a = 1
[ 1635.124000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1635.124000] drivers/hid/hid-core.c: report 6 (size 4) =  01 aa 00 00
[ 1635.124000] hid-debug: input ff80.0001 = 1
[ 1635.124000] hid-debug: input ff80.0001 = 170
[ 1635.124000] hid-debug: input ff80.0001 = 0
[ 1635.124000] hid-debug: input ff80.0001 = 0
[ 1635.236000] drivers/hid/hid-core.c: report (size 5) (numbered)
[ 1635.236000] drivers/hid/hid-core.c: report 5 (size 4) =  00 00 00 00
[ 1635.236000] hid-debug: input ffbc.005a = 0
[ 1635.236000] hid-debug: input ffbc.0000 = 1

Thanks a million. :)

