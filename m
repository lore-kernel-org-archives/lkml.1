Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZDOEcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZDOEcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZDOEca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:32:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:1415 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZDOEc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:32:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QBr45pui473xp/1Cs4+Vls+p3nNZj8J1Nzm+np8a8VFVz8ecewj9VOVjHGjglb70TL
         X4qUZBtp0p7KfHvbAOk6T+esDWftKQrJvLRGdSjWMBntGB2bShO0/O3abF+I26MmYWoa
         MQJ9q6Kxii8jWf0H1YZnBpapjUF4fqUBPPqr8=
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
In-Reply-To: <20090414205635.GA5968@nowhere>
References: <1239610670.6660.49.camel@tropicana>
	 <20090414205635.GA5968@nowhere>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 23:32:25 -0500
Message-Id: <1239769945.7852.21.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 22:56 +0200, Frederic Weisbecker wrote:
> On Mon, Apr 13, 2009 at 03:17:50AM -0500, Tom Zanussi wrote:

[...]

> 
> 
> BTW, this issue might be already present before this patch.
> What happens if:
> 
> 
> 	T1				T2
> 
> event_filter_read() {
>   filter_print_preds() {
>     for (i = 0; i < n_preds; i++) {
> 	pred = preds[i];
> 				    event_filter_write() {
> 					filter_disable_preds();
> 					filter_clear_preds() {
> 					  kfree(pred->field_name);
> 	field_name = pred->field_name;
> 	// CRASH!!!
> 
> 
> You need a mutex to protect these two callbacks.
> It would also protect concurrent calls to event_filter_write(),
> which would result in random.
> 

Yeah, Li Zefan had already fixed this, but it wasn't included in this
patch.  Looks like he'll be resubmitting that part...

> 
> 

[...]

> Also, is filter_add_pred() supposed to be available for in-kernel
> uses by other tracers or something?

No, the current callers were the only ones I'd planned on (it's not
static because code in trace_events.c needs to call it).  But, do you
see a use for it by other tracers?

> If this is planned, the locking could be even deeper than my comments.
> 
> Other than these comments:
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Thanks!
> 

Thanks for reviewing it!

Tom

