Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913Ab0ARM57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab0ARM57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353Ab0ARM56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:57:58 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55549 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab0ARM54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:57:56 -0500
Message-ID: <4B545ACF.40203@cs.helsinki.fi>
Date: Mon, 18 Jan 2010 14:57:51 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <1263740593.557.20967.camel@twins>	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>	 <4B545146.3080001@redhat.com>	 <20100118124419.GC1628@linux.vnet.ibm.com> <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com> <4B5459CA.9060603@redhat.com>
In-Reply-To: <4B5459CA.9060603@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 02:51 PM, Pekka Enberg wrote:
>> And how many probes do we expected to be live at the same time in
>> real-world scenarios? I guess Avi's "one million" is more than enough?

Avi Kivity kirjoitti:
> I don't think a user will ever come close to a million, but we can 
> expect some inflation from inlined functions (I don't know if uprobes 
> replicates such probes, but if it doesn't, it should).

Right. I guess we're looking at few megabytes of the address space for 
normal scenarios which doesn't seem too excessive.

However, as Peter pointed out, the bigger problem is that now we're 
opening the door for other features to steal chunks of the address 
space. And I think it's a legitimate worry that it's going to cause 
problems for 32-bit in the future.

I don't like the idea but if the performance benefits are real (are 
they?), maybe it's a worthwhile trade-off. Dunno.

			Pekka
