Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbYK0PKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbYK0PKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYK0PJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:09:54 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:43484 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYK0PJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:09:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rJpFGXfpOiKe2OjGn0ZNxsu70BlBhgpm8ASjLU30gQQ1MbN5/jL96LdctVTdLxDij+
         c5s1i3FH3FxGBu6pDa2UCjDMDfetrLWByRnZ97dqWsFADhSDAru1DPlHa+b1HikCSabc
         BLoF670JKkk8kooYW/DbobUWmsfcM3Q2IMDnI=
Message-ID: <c62985530811270709g3c0f343eof859d299cc786ce8@mail.gmail.com>
Date: Thu, 27 Nov 2008 16:09:52 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the trace output
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20081127150343.GA10188@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu>
	 <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com>
	 <20081127135155.GA23076@elte.hu>
	 <c62985530811270644r2de621ecwfdeb1d353197bdae@mail.gmail.com>
	 <20081127144648.GB4672@elte.hu>
	 <c62985530811270658x47f4f950m6c4c71f8674d27f1@mail.gmail.com>
	 <20081127150343.GA10188@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 Ingo Molnar <mingo@elte.hu>:
> if you look at it on a console where you look at code, it all looks
> like a straight line:
>
>
>  0)             |  sys_read() {
>  0)    0.331 us |    fget_light();
>  0)             |    vfs_read() {
>  0)             |      rw_verify_area() {
>  0)             |        security_file_permission() {
>  0)    0.306 us |          cap_file_permission();
>  0)    0.300 us |          cap_file_permission();
>  0)    8.909 us |        }
>  0)    0.993 us |      }
>  0)   11.649 us |    }
>  0)             |    do_sync_read() {
>                 .   -------------------------
>  0)             ==> [ bash-2794 => cat-1234 ]
>                     -------------------------
>
>
> as if the code to the right was on a sheet of paper.
>
> If i understand you correct, are you suggesting this format:
>
>  0)             |  sys_read() {
>  0)    0.331 us      fget_light();
>  0)             |    vfs_read() {
>  0)             |      rw_verify_area() {
>  0)             |        security_file_permission() {
>  0)    0.306 us            cap_file_permission();
>  0)    0.300 us            cap_file_permission();
>  0)    8.909 us          }
>  0)    0.993 us        }
>  0)   11.649 us      }
>  0)             |    do_sync_read() {
>                 .   -------------------------
>  0)             ==> [ bash-2794 => cat-1234 ]
>                     -------------------------
>
> i dont think that looks very good.


Hmm. I must confess that it draws a useful boundary for the eyes.
Ok.
