Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbYK0Pb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbYK0Pb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYK0PbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:31:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64175 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYK0PbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:31:16 -0500
Date: Thu, 27 Nov 2008 10:31:13 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
 trace output
In-Reply-To: <c62985530811270644r2de621ecwfdeb1d353197bdae@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811271028260.18691@gandalf.stny.rr.com>
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu>  <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com>  <20081127135155.GA23076@elte.hu> <c62985530811270644r2de621ecwfdeb1d353197bdae@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Nov 2008, Fr?d?ric Weisbecker wrote:
> >
> >> > ---------------------------------------------------------
> >> > CPU)     cost   |  function
> >> > ---------------------------------------------------------
> >> >
> >> >  0)             |  sys_read() {
> >> >  0)    0.331 us |    fget_light();
> >> >  0)             |    vfs_read() {
> >> >  0)             |      rw_verify_area() {
> >> >  0)             |        security_file_permission() {
> >> >  0)    0.306 us |          cap_file_permission();
> >> >  0)    0.300 us |          cap_file_permission();
> >> >  0)    8.909 us |        }
> >> >  0)    0.993 us |      }
> >> >  0)   11.649 us |+   }
> >> >  0)             |    do_sync_read() {
> >> >  0)             |      sock_aio_read() {
> >> >  0)             |        __sock_recvmsg() {
> >> >  0)             |          security_socket_recvmsg() {
> >> >  0)  100.319 us |!           cap_socket_recvmsg();
> >> > ---------------------------------------------------------
> >
> > Hm?
> 
> I like it before the CPU number. The main purpose would be to scroll
> quickly the file and find the overheads. That would be easy if set as
> a first character.

No, please keep the CPU # first.  If anything, you will want to separate 
out the CPUs first. Otherwise you will see things all mixed up.

Hmm, I could also add a per cpu files.

 debugfs/tracing/buffers/cpu0
 debugfs/tracing/buffers/cpu1
 debugfs/tracing/buffers/cpu2
 debugfs/tracing/buffers/cpu3

That would print out the trace for a single CPU.

BTW, I'm really not here. I'm on holiday eating turkeys.

-- Steve

