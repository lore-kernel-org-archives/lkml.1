Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbYKPGc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbYKPGc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYKPGcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:32:48 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:47821 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYKPGcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EVFdCPhZ1OBX/ku+qUr23mPa1wAgBQ4pKLhSVEi27ntzFocPGuHoisn0lLsi6HRykt
         IuVRmezXn5BcW/ghtLxSxR0TPGC+eK75/h7xKqXZWnaXHAHVZubTRHgVK1BSUFPOXdQ3
         0sPnMH9EWX87YS+2XELoCtI6QA4ITaxbv2QuY=
Message-ID: <c62985530811152232q2794ce1o6732c241821c6eca@mail.gmail.com>
Date: Sun, 16 Nov 2008 07:32:46 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/4] tracing/branch-tracer: Fix a trace recursion on branch tracer
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081116062213.GA32215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491FA8C8.1040905@gmail.com> <20081116062213.GA32215@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/16 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: Make the branch tracer use raw irq save/restore
>>
>> When the branch tracer inserts an event through
>> probe_likely_condition(), it calls local_irq_save() and then results
>> in a trace recursion.
>>
>> local_irq_save() -> trace_hardirqs_off() -> trace_hardirqs_off_caller()
>>       -> unlikely()
>>
>> The trace_branch.c file is protected by DISABLE_BRANCH_PROFILING but
>> that doesn't prevent from external call to functions that use
>> unlikely().
>>
>> My box crashed each time I tried to set this tracer (sudden and hard
>> reboot).
>
> So this patch fixes that problem, or are there other problems left?
>
>        Ingo
>


I forgot to answer to all. Yes that fixes it.
