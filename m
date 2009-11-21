Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZKUAUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZKUAUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZKUAUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:20:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZKUAUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:20:34 -0500
Message-ID: <4B073224.5050908@zytor.com>
Date: Fri, 20 Nov 2009 16:19:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump patching
 without stop_machine
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <4B071000.9080408@zytor.com> <4B072EF5.2090402@redhat.com>
In-Reply-To: <4B072EF5.2090402@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2009 04:06 PM, Masami Hiramatsu wrote:
> 
> If we don't care about NMI, we can use stop_machine() (for
> this reason, kprobe-jump-optimization can use stop_machine(),
> because kprobes can't probe NMI code), but tracepoint has
> to support NMI.
> 

Ingo pointed out that the NMI issue can be dealt with by having the NMI
handler check a flag if code modification is in progress on the entry to
the NMI handler.  So yes, NMI can trap out of the IPI hold, but it will
not go any further.

	-hpa
