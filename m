Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbYLTNPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYLTNPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 08:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYLTNPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 08:15:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:41716 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYLTNPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 08:15:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s1bZyAAeezJ9lRSVRT8KckcLQluo4nCe6IFuzAmPwdhS3r/OgKX4q/V9Xca/PxkR2B
         xqO/TFlwXvaC5wx8FSdmcY70WFVuVbEj771SJMfcxNjyAFFizVzW05lReVrr4Nfd3QSF
         xoiPFG8ZHlsa3oZUncxsw26WeBxA7ak7sE39Y=
Message-ID: <c62985530812200515x2e61c5f1ia1319495726bca0c@mail.gmail.com>
Date: Sat, 20 Dec 2008 14:15:08 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: introduce tracing_reset_online_cpus() helper
Cc: "Pekka J Enberg" <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, "Pekka Paalanen" <pq@iki.fi>,
       "Markus Metzger" <markus.t.metzger@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
	 <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
	 <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/19 Steven Rostedt <rostedt@goodmis.org>:
>
> On Fri, 19 Dec 2008, Fr?d?ric Weisbecker wrote:
>>
>>
>> That's looks good.
>> By the past, I also suggested Steven to automatically reset the traces
>> buffer each time a tracer is started, that
>> would factor out the code a bit more. I don't think one tracer would
>> avoid to reset the buffer once it is started, and
>> I don't think it is needed to reset twice on tracer switching: on stop
>> of the old tracer and on start on the new. Only
>> on start should be enough.
>
> I'm actually against the idea of reseting a trace everytime we enable it.
> That is:
>
> echo 1 > /debug/tracing/tracing_enabled
>
> This should not reset the tracer. I actually do tracing where I disable
> and enable it around areas I am interested in. I want all tracing, not
> just the last one.
>
> Now we have recently added /debug/tracing/tracing_on which can quickly
> stop tracing. I may be able to use that, and we can let the
> tracing_enable" reset it too.
>
> I'll have to take a look at my scripts to see if that would work.


Ok.
Actually perhaps that could be useful to do it only before calling the
init callback of a tracer.
That should be the only place where a tracer would want to reset the buffers....
