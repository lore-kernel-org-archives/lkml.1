Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZJWRAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZJWRAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 13:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZJWRAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 13:00:10 -0400
Received: from claw.goop.org ([74.207.240.146]:59497 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZJWRAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 13:00:09 -0400
Message-ID: <4AE1E117.2000005@goop.org>
Date: Fri, 23 Oct 2009 10:00:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Daniel Walker <dwalker@fifo99.com>, Erwan Velu <erwanaliasr1@gmail.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI	table
 is present
References: <4AE178AF.3010804@gmail.com> <20091023110323.GC10071@elte.hu> <4AE19867.5070705@gmail.com> <1256302066.10493.74.camel@desktop> <4AE1C5C6.7000103@gmail.com> <1256310576.10493.78.camel@desktop> <20091023153027.GA18068@elte.hu>
In-Reply-To: <20091023153027.GA18068@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/09 08:30, Ingo Molnar wrote:
>> Ingo mentioned that the returning mechanism your adding was left out 
>> intentionally to catch this error, so I don't think your original 
>> patch could be included ..
>>     
> Yes. That mechanism found a real bug here.
>
> Calling the DMI code too early (when the strings are still empty) can 
> cause silent failures: we wont crash but we might miss to act on DMI 
> quirks.
>   

Yes.  There's nothing preventing the DMI subsystem from being
initialized under Xen; in fact we rely on it in a dom0 kernel (which
does have access to the DMI tables).  I don't know what the underlying
bug in the original report is, but there's more to it than failing to
init DMI.

    J
