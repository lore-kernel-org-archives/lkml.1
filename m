Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYLHNin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYLHNin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYLHNie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:38:34 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:19921 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYLHNid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=azRHmv7BEAEAKCobX2lCQznsnqtN7vbQjmZsVoRbT90ROPqhQCi3WL+L/vyBoKI8RX
         qN0xhGt/62hSEX7pST8xVrxP7idW2Wo2dUEAM/Y4DT9nKK3KA2jDFmMuSHvNO71h7WEo
         FI4gCqYvL+lGtytPPQFvu51T7rEsuo6w0oT60=
Message-ID: <c62985530812080538p3802f329vf6e12695d734f16d@mail.gmail.com>
Date: Mon, 8 Dec 2008 14:38:31 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: signal interrupts entry/exit points on outpout
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1228717172.23742.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493C7058.4060709@gmail.com> <1228717172.23742.1.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/8 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Mon, 2008-12-08 at 01:54 +0100, Frederic Weisbecker wrote:
>> Impact: provide interrupt detection on output
>>
>> Suggested by Ingo.
>> If a hardirq is raised, we want it to be signaled on output, so this patch
>> adds two arrows on the output to find entry and exit points of a hardirq.
>>
>> Unfortunately, there are many interrupt entrypoints and these can be differents
>> from one arch to another.
>>
>> The approach here is one of the easiest, but doesn't shine by its scalability:
>> we have an array of the interrupt entrypoints names that we compare with the
>> symbol of the current traced function, if it matches, we draw the arrow.
>>
>> Ie:
>>
>>  1)               |                                unlock_buffer() {
>>  1)               |                                  wake_up_bit() {
>>  1)               |                                    bit_waitqueue() {
>>  1)   0.872 us    |                                      __phys_addr();
>>  1)   2.722 us    |                                    }
>>  1)               |                                    __wake_up_bit() {
>>  1)              ==>                                   __wake_up_bit() {
>>  1)               |                                      do_IRQ() {
>
> Would be much nicer, the current proposal is lost when grepping and adds
> a weird visual break in the output.


Ok, I will apply it like this in the V2.
Thanks!
