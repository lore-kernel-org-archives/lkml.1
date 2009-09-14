Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZINRSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZINRSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZINRSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:18:34 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:6534 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750867AbZINRSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:18:34 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cleanup legacy console_print function
Date: Mon, 14 Sep 2009 10:18:23 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501F0FEBC@exchange.ZeugmaSystems.local>
In-Reply-To: <alpine.LFD.2.01.0909140749300.3654@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cleanup legacy console_print function
Thread-Index: Aco1Supichj9jFoiTHyd75twhyBKaAAFBNAA
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local> <20090825172640.af8b9f58.randy.dunlap@oracle.com> <DDFD17CC94A9BD49A82147DDF7D545C501EA93B4@exchange.ZeugmaSystems.local> <alpine.LFD.2.01.0908271233580.3218@localhost.localdomain>  <DDFD17CC94A9BD49A82147DDF7D545C501F0FD30@exchange.ZeugmaSystems.local> <alpine.LFD.2.01.0909140749300.3654@localhost.localdomain>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>On Fri, 11 Sep 2009, Anirban Sinha wrote:
>>
>> -           console_print(text); \
>> -           console_print("\n"); \
>> +           printk(KERN_EMERG "%s", text);      \
>> +           printk(KERN_EMERG "\n");            \
>
>Just clean it up to be
>
>	printk(KERN_EMERG "%s\n", text);
>
>instead while at it.
>
>>  #define TRACE_CHR(chr) \
>>  	{ \
>>  	  if(dtlk_trace) \
>> -	    console_print(chr); \
>> +	    printk(KERN_EMERG "%c", chr); \
>
>That can't be right. The translation is to use "%s", not "%c".

Better still, for both the above cases, I will simply remove those macro
definitions. They are enclosed within {#if0 #endif}, so no code could
possibly be using it. If anyone has any strong reasons for keeping it
still, please raise your voice now.

Cheers,

Ani

