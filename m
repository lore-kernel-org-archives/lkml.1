Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYLMBZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYLMBZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 20:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYLMBZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 20:25:19 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:47609 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYLMBZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 20:25:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qA8M1rVtGj5lTP6c6PmD9lL76IT7DHo1h34bl6xZb4hiMBzSS9sGddnoj2+R0NKRko
         xVZ3C3wLzvKxKP1+mwyd1Q9ofXyIgasKhmry8OP23CSXFZFdN33DmxOgaJohB1/Aqm01
         8xesdxTtCIQ3TOFUDFs3VBSaNhzToQ+D5D06s=
Message-ID: <c62985530812121725m19b779d8o2c274efecdca93ab@mail.gmail.com>
Date: Sat, 13 Dec 2008 02:25:16 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Vladislav Bolkhovitin" <vst@vlnb.net>,
       "Sam Ravnborg" <sam@ravnborg.org>, linux-scsi@vger.kernel.org,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Mike Christie" <michaelc@cs.wisc.edu>, "Jeff Garzik" <jeff@garzik.org>,
       "Boaz Harrosh" <bharrosh@panasas.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       "Bart Van Assche" <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       fweisbec <fweisbec@gmail.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH][RFC 2/23]: SCST core
In-Reply-To: <20081212230523.GB4775@ghostprotocols.net>
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
	 <20081212230523.GB4775@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/13 Arnaldo Carvalho de Melo <acme@redhat.com>:
> Steven, is it possible to trigger tracing for any function when a
> function in the list set up by the user is running and then stop tracing
> when it exits?
>
> - Arnaldo
>

Hi Arnaldo,

Yes it's possible with ftrace, by using the function graph tracer ( an
ftrace extension that adds the tracing on return).

To enable it just do:
echo function_graph > /debugfs/tracing/current_tracer

And to trace by choosing a particular function as the root of the call
stack, just do the things
 explained on this patch:
http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a=commit;h=ea4e2bc4d9f7370e57a343ccb5e7c0ad3222ec3c

And the tracing will finish after this function returns :-)
