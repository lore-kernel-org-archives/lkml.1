Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752Ab0ANPmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0ANPmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583Ab0ANPmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:42:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47471 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0ANPmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:42:14 -0500
Message-ID: <4B4F3A1A.2030906@zytor.com>
Date: Thu, 14 Jan 2010 07:36:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com>	 <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com>
In-Reply-To: <1263483139.28171.3857.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 07:32 AM, Steven Rostedt wrote:
>> +
>> +	/* Replacing 1 byte can be done atomically. */
>> +	if (unlikely(len <= 1))
>> +		return text_poke(addr, opcode, len);
> 
> This part bothers me. The text_poke just writes over the text directly
> (using a separate mapping). But if that memory is in the pipeline of
> another CPU, I think this could cause a GPF.
> 

Could you clarify why you think that?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

