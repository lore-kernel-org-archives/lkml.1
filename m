Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYGWNUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYGWNUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYGWNU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:20:28 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:59481 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbYGWNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:20:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAPrIhkhMRKxB/2dsb2JhbACBWrB0
Date: Wed, 23 Jul 2008 09:20:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Avi Kivity <avi@qumranet.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jan Kiszka <jan.kiszka@siemens.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
Message-ID: <20080723132024.GC15401@Krystal>
References: <20080717155724.897537670@polymtl.ca> <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com> <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com> <48862B01.7070907@qumranet.com> <1216799346.7257.125.camel@twins> <4886E6FD.4090200@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4886E6FD.4090200@qumranet.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:16:11 up 48 days, 17:57,  4 users,  load average: 0.64, 0.53,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@qumranet.com) wrote:
> Peter Zijlstra wrote:
>> On Tue, 2008-07-22 at 21:46 +0300, Avi Kivity wrote:
>>   
>>> Jan Kiszka wrote:
>>>     
>>>> That's true - as long as you don't have to add/remove/modify
>>>> tracepoints. I had to do this job in the past (not for KVM). Having 1
>>>> spot in 1 file (based on generic probes) would be handier in that case
>>>> than 5 spots in 3 files. But if the KVM tracepoints are considered
>>>> stable in their number and structure, that shouldn't be an issue here.
>>>>
>>>>         
>>> Tracepoints aren't stable; they are artefacts of the implementation.
>>>     
>>
>> Which IMHO makes it unsuitable for trace_mark() as that will be exported
>> to user-space, and every time you change your tracepoints you'll change
>> user visible things - not nice.
>>   
>
> They are used for debugging (mostly performance related), so changes are 
> expected.
>
> What uses of trace_mark() depend on a stable interface? blktrace?
>

Actually, LTTng likes to have the { marker name, field name } pairs
unchanged for the markers it looks for, but that's about it. If a
userspace analysis plugin fails to see a marker (because it is disabled
or changed), it just does not apply its particular analysis on the
trace.

Since the markers and marker types are self-described in the trace,
userspace can detect any change the the present markers, so there is no
need to rely on "version numbers" because we are able to proceed to a
complete marker list verification (names, field names, types) before
starting the trace analysis.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
