Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbXGFLDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbXGFLDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbXGFLDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:03:44 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:28798 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758032AbXGFLDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:03:44 -0400
X-YMail-OSG: WOFH2J8VM1nFGMc8CSA3BPdIq_6veCdPmK8y9asjDOBvB5LBanyEtXBy7AjqcYomeJqHuokEr0KS06UL4H3T_qrxbw--
X-RocketYMMF: knobi.rm
Date: Fri, 6 Jul 2007 04:03:41 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Reply-To: knobi@knobisoft.de
Subject: Re: Understanding I/O behaviour
To: linux-kernel@vger.kernel.org
Cc: spam trap <spamtrap@knobisoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <543242.2447.qm@web32607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch wrote:
>--- Robert Hancock <hancockr@xxxxxxx> wrote:
>
>>
>> Try playing with reducing /proc/sys/vm/dirty_ratio and see how that
>> helps. This workload will fill up memory with dirty data very
>> quickly,
>> and it seems like system responsiveness often goes down the toilet
>> when
>> this happens and the system is going crazy trying to write it all
>> out.
>>
>
>Definitely the "going crazy" part is the worst problem I see with 2.6
>based kernels (late 2.4 was really better in this corner case).
>
>I am just now playing with dirty_ratio. Anybody knows what the lower
>limit is? "0" seems acceptabel, but does it actually imply "write out
>immediatelly"?
>
>Another problem, the VM parameters are not really well documented in
>their behaviour and interdependence.

 Lowering dirty_ration just leads to more imbalanced write-speed for
the three dd's. Even when lowering the number to 0, the hich load
stays.

 Now, on another experiment I mounted the FS with "sync". And now the
load stays below/around 3. No more "pdflush" daemons going wild. And
the responsiveness is good, with no drops.

 My question is now: is there a parameter that one can use to force
immediate writeout for every process. This may hurt overall performance
of the system, but might really help my situation. Setting dirty_ratio
to 0 does not seem to do it.

Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
