Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYK0O6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYK0O6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYK0O61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:58:27 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:57080 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYK0O60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GmT6/9seqBimFWV3LQf/17ZQwB86EL+dWw+7sVidw745Jck5TdisVxEhHP8/tpEYPN
         qVVuxTq0nU+Sr85vkJ8MjftLhCgBtNq308dhp6H+n2ZSnI70OfU3vSZBv+fI7ZWCbwnC
         4jeEyh+cDtWIkhk4gabg7tT8jMjmFJZoRbPr0=
Message-ID: <c62985530811270658x47f4f950m6c4c71f8674d27f1@mail.gmail.com>
Date: Thu, 27 Nov 2008 15:58:25 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the trace output
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20081127144648.GB4672@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu>
	 <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com>
	 <20081127135155.GA23076@elte.hu>
	 <c62985530811270644r2de621ecwfdeb1d353197bdae@mail.gmail.com>
	 <20081127144648.GB4672@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> >> >  0)    0.993 us |      }
>> >> > +0)   11.649 us |    }
>> >> >  0)             |    do_sync_read() {
>> >> >  0)             |      sock_aio_read() {
>> >> >  0)             |        __sock_recvmsg() {
>> >> >  0)             |          security_socket_recvmsg() {
>> >> > !0)  100.319 us |            cap_socket_recvmsg();
>> >> > ---------------------------------------------------------
>>
>> I like it before the CPU number. The main purpose would be to scroll
>> quickly the file and find the overheads. That would be easy if set
>> as a first character.
>>
>> I will set it as a default disabled option.
>
> lets keep it default-enabled, ok? It makes sense.

Ok.
BTW I understand why it is better to have a "pipe" if there is no time:

  0)             |    do_sync_read() {
  0)             |      sock_aio_read() {
  0)             |        __sock_recvmsg() {
  0)             |          security_socket_recvmsg() {

But I don't see why it is necessary to have one just after the time:

!0)  100.319 us |            cap_socket_recvmsg();

It appears to me as noise....
