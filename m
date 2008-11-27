Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYK0Ox1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYK0Ox1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYK0OxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:53:18 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:59952 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYK0OxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:53:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WhZr+RThxfk8vVykseF0q3O8I/EHt7bvw6Fb1kVX75GZtN0HXfwtcLP4oBAu0UYJAK
         kKuRyONfWTJAZCCugbBCedKxCaz90fNkz9lKrwFrsc+Mx+sIKDkpcbEcTcr0WA69m7ot
         GQK/ErjridSiME5587SplfzpxU75FMBfM3e6w=
Message-ID: <c62985530811270653y644295d6x57de6be7a51be667@mail.gmail.com>
Date: Thu, 27 Nov 2008 15:53:16 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the trace output
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1227781146.4454.1369.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492DEDE9.9010109@gmail.com> <1227781146.4454.1369.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 Peter Zijlstra <peterz@infradead.org>:
> Furthermore, it would be really sweet if ftrace_printk() output would be
> at the right indentation level wrt the function it was called from. eg.
>
> CPU[000] -          do_sync_read() {
> CPU[000]              # sock: 0x12345 flag: 1
> CPU[000] -            sock_aio_read() {
> ...
> CPU[000] + 0.123    }
>
>
> Where the # line is the ftrace_printk() output.


I didn't think of ftrace_printk yet.
That's a good idea, this way we will see where the ftrace_printk was
called, in which
function at which depth....

Don't you think that would be better to have it as C comments.
We are in a C-style output and ftrace_printk are especially designed for
comments in a trace.
That would make sense to read:

       do_sync_read() {
          /* sock: 0x12345 flag: 1 */
          sock_aio_read() {
0.123 }
