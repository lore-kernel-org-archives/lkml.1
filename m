Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZCGUAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZCGUAQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 15:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZCGUAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 15:00:01 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:62086 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbZCGUAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 15:00:00 -0500
Message-ID: <49B2D23C.8000004@free.fr>
Date: Sat, 07 Mar 2009 20:59:56 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg Kurz <gkurz@fr.ibm.com>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Containers <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       roland@redhat.com
Subject: Re: [PATCH 0/7][v8] Container-init signal semantics
References: <20090219030207.GA18783@us.ibm.com> <499D73C8.3090209@free.fr>	 <20090307190428.GA30594@us.ibm.com>  <49B2CE6E.3090501@free.fr> <1236455509.9151.4.camel@bahia>
In-Reply-To: <1236455509.9151.4.camel@bahia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kurz wrote:
> On Sat, 2009-03-07 at 20:43 +0100, Daniel Lezcano wrote:
>   
>>         case LINUX_REBOOT_CMD_HALT:
>> -               kernel_halt();
>> -               unlock_kernel();
>> -               do_exit(0);
>> +               if (power_off_pid_ns(current->nsproxy->pid_ns)) {
>> +                       kernel_halt();
>> +                       unlock_kernel();
>> +                       do_exit(0);
>> +               }
>>     
>
> Even if current will get SIGKILLed when zap_pid_ns_processes() is
> called, I see no reason it doesn't call do_exit(0).
Right and unlock_kernel too :)
>   
>>                 break;
>>
>>         case LINUX_REBOOT_CMD_POWER_OFF:
>> -               kernel_power_off();
>> -               unlock_kernel();
>> -               do_exit(0);
>> +               if (power_off_pid_ns(current->nsproxy->pid_ns)) {
>> +                       kernel_power_off();
>> +                       unlock_kernel();
>> +                       do_exit(0);
>> +               }
>>     
>
> Same.
>
>   
>>                 break;
>>
>>     

