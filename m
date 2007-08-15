Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbXHON6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbXHON6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXHON6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:58:42 -0400
Received: from smtpout.mac.com ([17.250.248.184]:60145 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbXHON6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:58:42 -0400
In-Reply-To: <Pine.LNX.4.64.0708151217120.5639@fbirervta.pbzchgretzou.qr>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org> <20070814232107.GA4265@aurum.uhlenkott.net> <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr> <46C2BB60.6010909@gmail.com> <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr> <46C2CE42.4010303@gmail.com> <Pine.LNX.4.64.0708151217120.5639@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5D056606-6284-4331-98DB-77123816D5B8@mac.com>
Cc: Rene Herman <rene.herman@gmail.com>,
       Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: kfree(0) - ok?
Date: Wed, 15 Aug 2007 09:58:29 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2007, at 06:20:27, Jan Engelhardt wrote:
> On Aug 15 2007 11:58, Rene Herman wrote:
>>>> NULL is not 0 though.
>>> It is.  Its representation isn't guaranteed to be all-bits-zero,
>>
>> He said the null _pointer_ isn't guaranteed to be all-bits zero.  
>> And it isn't. Read the standard or the faq.
>
> 0 is all-bits-zero.
> NULL is 0. ("It is.", above)
>
> Transitively, this would make NULL all-bits-zero.  I might have  
> missed something, though, perhaps that the cast to void* makes it  
> intransitive.  But leave it at whatever the standard says.
>
>> but the constant value 0 when used in pointer context is always a  
>> null pointer (and in fact the standard requires that NULL be  
>> #defined as 0 or a cast thereof).

Irrespective of whatever the standard says, EVERY platform and  
compiler anybody makes nowadays has a NULL pointer value with all  
bits clear.  Theoretically the standard allows otherwise, but such a  
decision would break so much code.  Linux especially, we rely on the  
uninitialized data to have all bits clear and we depend on that  
producing NULL pointers; if a NULL pointer was not bitwise exactly 0  
then the test "if (some_ptr != NULL)" would fail and we would start  
dereferencing garbage.

Cheers,
Kyle Moffett

