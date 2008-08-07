Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYHGTrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYHGTrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYHGTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:47:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39140 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752246AbYHGTr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:47:27 -0400
Message-ID: <489B5149.4030600@sgi.com>
Date: Thu, 07 Aug 2008 12:47:21 -0700
From: Jay Lan <jlan@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <200808061550.22996.nickpiggin@yahoo.com.au> <489B34BA.4060300@linux-foundation.org> <489B3A0D.7060706@s5r6.in-berlin.de> <489B48BF.3060609@linux-foundation.org>
In-Reply-To: <489B48BF.3060609@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Stefan Richter wrote:
>> Christoph Lameter wrote:
>>> The competing implementation is kdb not kgdb. kgdb is just a stub for
>>> remote
>>> debugging using gdb. kdb is an in-kernel debugger like the one
>>> proposed here.
>> Is there work underway to get kdb merged?  (I'm just asking because I
>> don't know; I personally don't need kdb nor mdb.)
> 
> KDB still exists in patches but the merge effort was given up when Linus
> stated that he did not want a kernel debugger. No problem to start merge
> attempts again AFAICT. Jay?

To merge KDB or any other RAS tools, you need to deal with kdump. Kdump
hijack panic() before the die calling chain. For KDB or a RAS tool to
work, an infrastructure such as the "add new notifier function" by
Takenori Nagano should be in place.

His last attempt fell short, in my opinion, was partly due to his
"[PATCH 3/3] Move crash_kexec() into  panic_notifier" did not do what it
meant to do: to fit kexec/kdump into the new infrastructure. That is
not fatal; it can be fixed to make it right. If community is interested
in getting a kernel debugger to the kernel, we can continue Takenori's
work. Once the infrastructure is accepted, then merging KDB or any other
kernel debugger will make sense.

Regards,
 - jay


> 

