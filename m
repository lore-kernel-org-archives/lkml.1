Return-Path: <linux-kernel-owner+w=401wt.eu-S1763522AbXGFKSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763522AbXGFKSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXGFKSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:18:42 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:34802 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759403AbXGFKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:18:41 -0400
X-YMail-OSG: zXsOFHQVM1m0gFqP1cT0Rm0N5RaOspOfWRY0eLUiR1AlIwnYlcOCaRz.BOHlN0LQw7OvGgZM1jZza2RAez4sRfHZNg--
X-RocketYMMF: knobi.rm
Date: Fri, 6 Jul 2007 03:18:40 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <773157.44861.qm@web32603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>    b) any ideas how to optimize the settings of the /proc/sys/vm/
>>    parameters? The documentation is a bit thin here.
>>
>>
>I cant offer any advice there, but is raid-5 really the best choice
>for your needs? I would not choose raid-5 for a system that is
>regularly performing lots of large writes at the same time, dont
>forget that each write can require several reads to recalculate the
>partity.
>
>Does the raid card have much cache ram?
>

 192 MB, split 50/50 to read write.

>If you can afford to loose some space raid-10 would probably perform
>better.

 RAID5 most likely is not the best solution and I would not use it if
the described use-case was happening all the time. It happens a few
times a day and then things go down when all memory is filled with
page-cache.

 And the same also happens when copying large amountd of data from one
NFS mounted FS to another NFS mounted FS. No disk involved there.
Memory fills with page-cache until it reaches a ceeling and then for
some time responsiveness is really really bad.

 I am just now playing with the dirty_* stuff. Maybe it helps.

Cheers
Martin



------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
