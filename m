Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXCEMuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXCEMuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933403AbXCEMuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:50:44 -0500
Received: from mailout06.sul.t-online.com ([194.25.134.19]:46741 "EHLO
	mailout06.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932344AbXCEMun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:50:43 -0500
X-Greylist: delayed 1088 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2007 07:50:43 EST
Message-ID: <45EC0DC7.8080504@t-online.de>
Date: Mon, 05 Mar 2007 13:32:07 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070303)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, "Wu, Bryan" <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
References: <1172722480.5264.75.camel@roc-desktop> <20070305092346.GB11664@linux-sh.org>
In-Reply-To: <20070305092346.GB11664@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: JO9950ZSoeS-I2Ua24kb27ZHeXP82GS-Ak-aaz9y9VSerFPYRmHGUX
X-TOI-MSGID: f992186d-05de-42c7-99be-7812eee833c8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
>> +comment "Memory Optimizations"
>> +
>> +config I_ENTRY_L1
>> +	bool "Locate interrupt entry code in L1 Memory"
>> +	default y
>> +	help
>> +	  If enabled interrupt entry code (STORE/RESTORE CONTEXT) is linked
>> +	  into L1 instruction memory.(less latency)
>> +
> Wow, this is really crying out for a special linker section with slightly
> more intelligent relocation logic. You should flag the performance
> critical parts to be located in L1 memory directly with a section
> attribute, rather than making everything selectable. If you overflow you
> can simply spill in to main memory.

This is done intentionally, because it's also possible for user code to 
be loaded into L1 memory.  We want to give users the option to avoid 
filling it all up with kernel code.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, Vincent Roche, Joseph E. McDonough
