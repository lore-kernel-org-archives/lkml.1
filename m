Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZHIXEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZHIXEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZHIXEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:04:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10393 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZHIXEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AhoAPjxhLyyTXR+Cwus6aJOyqauHdeh3NfvgxbdHCNr+Qde1XDstC5uJ7T+vcQYWzo
         miamIXyodHmdpP+XFRlkNgI188r4gjzX5IscrMR2U6HxWxyDe6K6XfJl1ab5F1tBIEaU
         pRs5UuLXhKbesWMjAEi0FVz7OrViEeAsHddb0=
Date: Mon, 10 Aug 2009 01:04:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf: store and retrieve trace event names in the perf.data file
Message-ID: <20090809230430.GB6089@nowhere>
References: <4A7F4463.3050508@linux.intel.com> <20090809224400.GA6089@nowhere> <4A7F554A.8080402@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7F554A.8080402@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 04:01:30PM -0700, Arjan van de Ven wrote:
> Frederic Weisbecker wrote:
>> On Sun, Aug 09, 2009 at 02:49:23PM -0700, Arjan van de Ven wrote:
>>> In order to be able to use trace events, a key aspect is the "type" field;
>>> this is the id of the event that you recorded, as stored in the /sys/kernel/debug/events/*/*/id file.
>>> What is currently missing is a way to map the id number (which is not abi stable)
>>> to the event that was recorded.
>>
>>
>>
>> We already have that.
>> See tools/perf/util/parse-events.c: char *tracepoint_id_to_name(u64 id)
>
>
> sadly... we don't.
>
> You do it *on the same boot and machine* as you created the perf.data file.
> You don't have it when you reboot into a new kernel, or move the perf.data file
> to a new machine........
>
> Which is to be honest a very common usecase.


Ah right... I always forget the offline report case.
But you can at least reuse this existing helper to resolve
the id to name.

