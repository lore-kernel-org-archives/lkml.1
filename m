Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYK0Oov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYK0Oov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYK0Oon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:44:43 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:48712 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbYK0Oom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:44:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BL2yF/cYXw1/2SzcHDUD/lHvN7LZpG6U8WUvQzVTzG6t9ucoQJHidst0gT8+o7bqPX
         +a/eyo1b6JjAx65TtlCtNLDigRgsdA4Ad66CR/yWh1m6fM5MNHAp/Vo5hdn/KWyZ7OQz
         Ho7X+/e2TdbbMS4D5VQL5aQG3mpc7JOI1Lax0=
Message-ID: <c62985530811270644r2de621ecwfdeb1d353197bdae@mail.gmail.com>
Date: Thu, 27 Nov 2008 15:44:40 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the trace output
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20081127135155.GA23076@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu>
	 <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com>
	 <20081127135155.GA23076@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 Ingo Molnar <mingo@elte.hu>:
> We can still add the overhead signs.
>
> We still have a single space in the first column before the CPU number
> (that looks better when these traces are pasted into email, which is
> one of the most common uses of them), and we can add the sign there.
>
> I.e. something like this:
>
>> > ---------------------------------------------------------
>> > CPU)     cost   |  function
>> > ---------------------------------------------------------
>> >
>> >  0)             |  sys_read() {
>> >  0)    0.331 us |    fget_light();
>> >  0)             |    vfs_read() {
>> >  0)             |      rw_verify_area() {
>> >  0)             |        security_file_permission() {
>> >  0)    0.306 us |          cap_file_permission();
>> >  0)    0.300 us |          cap_file_permission();
>> >  0)    8.909 us |        }
>> >  0)    0.993 us |      }
>> > +0)   11.649 us |    }
>> >  0)             |    do_sync_read() {
>> >  0)             |      sock_aio_read() {
>> >  0)             |        __sock_recvmsg() {
>> >  0)             |          security_socket_recvmsg() {
>> > !0)  100.319 us |            cap_socket_recvmsg();
>> > ---------------------------------------------------------
>
> Or we could add them to the function name bit - there we have two free
> space characters anyway:
>
> Something like this:
>
>> > ---------------------------------------------------------
>> > CPU)     cost   |  function
>> > ---------------------------------------------------------
>> >
>> >  0)             |  sys_read() {
>> >  0)    0.331 us |    fget_light();
>> >  0)             |    vfs_read() {
>> >  0)             |      rw_verify_area() {
>> >  0)             |        security_file_permission() {
>> >  0)    0.306 us |          cap_file_permission();
>> >  0)    0.300 us |          cap_file_permission();
>> >  0)    8.909 us |        }
>> >  0)    0.993 us |      }
>> >  0)   11.649 us |+   }
>> >  0)             |    do_sync_read() {
>> >  0)             |      sock_aio_read() {
>> >  0)             |        __sock_recvmsg() {
>> >  0)             |          security_socket_recvmsg() {
>> >  0)  100.319 us |!           cap_socket_recvmsg();
>> > ---------------------------------------------------------
>
> Hm?

I like it before the CPU number. The main purpose would be to scroll
quickly the file and find the overheads. That would be easy if set as
a first character.

I will set it as a default disabled option.



>
>> I don't know, perhaps that will actually be better in practice...
>
> i think it will be better. I'm biased, so i gave the output to two
> people with good visual taste (one of them female), [note, i gave them
> the mockup from the previous mail] and the first question of both of
> them was: "why arent the times on the left?".

Really?
Actually yes, I'm certainly biased too.

> I think we could make the time column a trace_option as well -
> default-enabled.

Ok, I will apply it.
