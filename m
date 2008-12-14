Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYLNAfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYLNAfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 19:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYLNAfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 19:35:21 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:3056 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYLNAfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 19:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TNQw/+76DZaMNnpRbs0TpzV7vk2Q6TloOc6pV6NVrwhVEombu6fR8BchPLS0GWF4Tu
         TTh4eDOILXkj+ZyAlWYx81udje//EA263+VlpPOUOr5QpNnGO2aPHEP/i9PVRxP1lxat
         pcccQS/tu+I3EfiJb83u6w8xeTmMPwaI8Pzwo=
Message-ID: <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
Date: Sun, 14 Dec 2008 01:35:18 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Vladislav Bolkhovitin" <vst@vlnb.net>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Cc: "Steven Rostedt" <srostedt@redhat.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       linux-scsi@vger.kernel.org,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Mike Christie" <michaelc@cs.wisc.edu>, "Jeff Garzik" <jeff@garzik.org>,
       "Boaz Harrosh" <bharrosh@panasas.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       "Bart Van Assche" <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4943CAAB.4050008@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net>
	 <20081210191213.GA15273@uranus.ravnborg.org>
	 <49414DBE.6070801@vlnb.net>
	 <20081211210917.GB27010@uranus.ravnborg.org>
	 <4942BA85.3070408@vlnb.net>
	 <1229118607.24995.18.camel@localhost.localdomain>
	 <4943CAAB.4050008@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/13 Vladislav Bolkhovitin <vst@vlnb.net>:
> Also (maybe I simply miss something) looks like ftrace doesn't trace exit
> from functions, only entrance to them. Is it true? Is it possibly to log
> exit from functions as well?


That's true with 2.6.28, the function tracer traces on function entries only.
But there is an add-on on ftrace which let one to trace on entry and
on return, the function
graph tracer. This tracer uses this facility to output a graph of
function calls and measure
the time elapsed during each function call.
You can also register two custom handlers to do some things you need
on entry and on return.


> All the above functionality is almost what we need. The only thing left,
> which I forgot to mention, is possibility to log also functions return value
> on exit. This is what TRACE_EXIT_RES() in SCST does. Is it possible to add
> those?


I want to add that on the function graph tracer. That can be done
pretty easily. The only
problem comes with the type of the return value. Would this tracer be
supposed to always
return a 64 bits value regardless of the real typ of the value? There
would be some pointless bytes
on most return values. I don't know how to proceed for this problem.

> And one more question. Is it possible to redirect ftrace tracing to serial
> console or any other console (netconsole?)? It can be helpful to investigate
> hard lockups in IRQ or with IRQs disabled.
>
> Thanks!
> Vlad
>

I would find it useful too. I thought about something like using
early_printk or something like
that...I don't know. That would be good to redirect the output to the
tty device of the user choice.
