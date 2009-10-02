Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZJBUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZJBUnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbZJBUnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:43:17 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:60887 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136AbZJBUnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:43:16 -0400
Message-ID: <4AC665E4.8060200@mandriva.org>
Date: Fri, 02 Oct 2009 23:43:16 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "astarikovskiy@suse.de" <astarikovskiy@suse.de>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
References: <51f3faa70909282134o1d60efekeded09f09b192df6@mail.gmail.com> <68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com> <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com> <4AC21E7B.70000@mandriva.org> <51f3faa70909301638s4eff14edg46420e2e8877fd15@mail.gmail.com> <20091001085002.1dbc7eee@hyperion.delvare> <51f3faa70910010740s2a412d07qf29f56ad8a3c59eb@mail.gmail.com> <20091001144914.GA18675@nb-core2.darkstar.lan> <4AC4D6F5.6080005@mandriva.org> <68676e00910011205t506604e5y5a0a04fec0821dc0@mail.gmail.com> <20091002122636.GA25505@nb-core2.darkstar.lan>
In-Reply-To: <20091002122636.GA25505@nb-core2.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> On Thu, Oct 01, 2009 at 09:05:36PM +0200, Luca Tettamanti wrote:
>> On Thu, Oct 1, 2009 at 6:21 PM, Thomas Backlund <tmb@mandriva.org> wrote:
>>>>
>>> I tried your latest patch on a P7P55D Deluxe and get this:
>>>> [   10.419119] ACPI Error: Field [PR11] at 64 exceeds Buffer [NULL] size
>>>> 32 (bits) (20090903/dsopcode-596)
>>>> [   10.419125] ACPI Error (psparse-0537): Method parse/execution failed
>>>> [\_SB_.PCI0.SBRG.ASOC.GITM] (Node ffff88023f8147a0), AE_AML_BUFFER_LIMIT
>>>> [   10.419157] ATK0110 ATK0110:00: GITM[0x11060004] ACPI exception:
>>>> AE_AML_BUFFER_LIMIT
>>>> [   10.419158] ATK0110 ATK0110:00: Unable to query EC status
>>>> [   10.419161] ATK0110: probe of ATK0110:00 failed with error -5
>> I see. GITM probably expects the same buffer structure as SITM, though
>> in older models the upper bits were never used (hence I never noticed
>> the problem). Working on a patch.
> 
> Ok, here it is:
> 

no go...

[root@thunder ~]# modprobe asus_atk0110
Killed
[root@thunder ~]#
Message from syslogd@thunder at Fri Oct  2 23:39:34 2009 ...
thunder klogd: [ 2270.697739] Oops: 0002 [#1] PREEMPT SMP

Message from syslogd@thunder at Fri Oct  2 23:39:34 2009 ...
thunder klogd: [ 2270.697741] last sysfs file: /sys/module/ipv6/initstate

Message from syslogd@thunder at Fri Oct  2 23:39:34 2009 ...
thunder klogd: [ 2270.697792] Stack:

Message from syslogd@thunder at Fri Oct  2 23:39:34 2009 ...
thunder klogd: [ 2270.697799] Call Trace:

Message from syslogd@thunder at Fri Oct  2 23:39:34 2009 ...
thunder klogd: [ 2270.697851] Code: eb 0e 4c 89 e7 e8 a3 ff ff ff 48 89 
43 08 eb 05 48 39 f0 72 1c 48 8b 53 08 b8 04 00 00 00 48 85 d2 74 13 31 
c0 48 89 d7 4c 89 e1 <f3> aa 31 c0 eb 05 b8 0b 00 00 00 5b 41 5c c9 c3 
55 48 8b 3d 27

Message from syslogd@thunder at Fri Oct  2 23:39:34 2009 ...
thunder klogd: [ 2270.697870] CR2: 0000000000000011

--
Thomas
