Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYHYN7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYHYN7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYHYN7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:59:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:35047 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbYHYN7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MEnrw8eVBD4yhV0Zw85O6gegsHrawDVzti6n41iA9ByyAWhlaAXPHV2WW77y4RlamA
         wX9VNyHM3grF+a5iVpzaMwhMq6YS8hNd0oztx6xWpZXnd5B93g0RhnbvFeujWoEGrwU+
         JVtD6Rh15zCrhx4Z8kPSA+wq+eX/4OA9oo6oA=
Message-ID: <c62985530808250659w5b2a2f83u689987969a4cb53d@mail.gmail.com>
Date: Mon, 25 Aug 2008 14:59:41 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080825084405.GA29195@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48B1D5CA.8000607@gmail.com> <20080825084405.GA29195@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/25 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> The documentation of mmiotrace describes an unimplemented feature
>> which allows the user to write any comments on his trace by writing on
>> a tracing/marker file. Here is an implementation of this idea.
>>
>> It applies on last version of tip tree.
>
> hmm ... have you looked at the (recently implemented) ftrace_printk()
> facility?
>
>        Ingo
>

Yes but I didn't want to use ftrace_printk() because it needs the "ip"
parameter. User messages doesn't need this. But I reuse a part of the
code of ftrace_printk and I splitted ftrace_printk() in two parts for
this purpose: __ftrace_printk() and trace_print().
I also reused the print_entry but with a new TRACE_MARK type to make
the difference when it is time to send the entry to the pipe because
user messages don't use ip.
