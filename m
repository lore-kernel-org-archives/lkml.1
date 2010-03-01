Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0CAW5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 17:57:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47896 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab0CAW5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:57:20 -0500
Message-ID: <4B8C463B.7070900@zytor.com>
Date: Mon, 01 Mar 2010 14:56:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, avi@redhat.com, mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com> <4B8BE7C1.40000@redhat.com> <20100301174724.GA12867@redhat.com> <4B8C09F5.9070506@redhat.com> <20100301190341.GD12867@redhat.com> <4B8C1320.6060602@redhat.com> <4B8C4032.7080703@zytor.com>
In-Reply-To: <4B8C4032.7080703@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 02:31 PM, H. Peter Anvin wrote:
> On 03/01/2010 11:18 AM, Zachary Amsden wrote:
>>
>> It's going to be ugly to emulate segmentation, NX and write protect 
>> support without hardware to do this checking for you, but it's just what 
>> you have to do in this slow path - tedious, fully specified emulation.
>>
>> Just because it's tedious doesn't mean we need to use setjmp / longjmp.  
>> Throw / catch might be effective, but it's still pretty bizarre to do 
>> tricks like that in C.
>>
> 
> Well, setjmp/longjmp really is not much more than exception handling in C.
> 

For what it's worth, I think that setjmp/longjmp is not anywhere near as
dangerous as people want to make it out to be.  gcc will warn for
dangerous uses (and a lot of non-dangerous uses), but generally the
difficult problems can be dealt with by moving the setjmp-protected code
into a separate function.

	-hpa
