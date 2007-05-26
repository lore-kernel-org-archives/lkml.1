Return-Path: <linux-kernel-owner+w=401wt.eu-S1763641AbXEZQi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763641AbXEZQi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbXEZQiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:38:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:54092 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbXEZQiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:38:20 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: double exclamation (!!) suckage in the kernel
To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Miller <davem@davemloft.net>, satyam.sharma@gmail.com,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sat, 26 May 2007 18:38:07 +0200
References: <8oOAk-4mP-3@gated-at.bofh.it> <8oPmF-5Fb-21@gated-at.bofh.it> <8p4OH-3N0-15@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HrzHL-0000s2-Pv@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18RcKxttbRawy9hRR743aMu6R4BC8VINx2RvHT
 gSn9sEJ+vzmTRWtwrSWxbtH64YftUlAVRSpDt0RjbpCaOTjxQD
 RdZqcuK5MauAavqOeOhBQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> On May 25 2007 14:14, David Miller wrote:

>>"!!" is used in contexts where pointers might be being
>>tested as well as plain integers, the "!!" turns a pointer
>>into the equivalent integer boolean for testing.
>>
>>NULL pointers become 0
>>non-NULL pointers become 1
> 
> Though,
> if(!!ptr)
> is effectively the same as
> if(ptr)

Not exactly, if(foo) is the same as if( (int) foo), which is not
guaranteed to result in non-null values for non-null pointers.
ISO 9899/1999 says: "Any pointer may be converted to an integer type. [...]
         The result need not be in the range of values of any integer type."

"if(!!foo)" is the same as "if(0 == (0 == foo))", which is (I asume) the same
as "if(0 == ((type_of_foo)NULL == foo))", or if((type_of_foo)NULL != foo).
-- 
Funny quotes:
11. Atheism is a non-prophet orgainization.

Friﬂ, Spammer: bj@eTTCYWgi.7eggert.dyndns.org IsWw@efwjh45.7eggert.dyndns.org
