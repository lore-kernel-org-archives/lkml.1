Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZJJP2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZJJP2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZJJP2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:28:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZJJP2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:28:40 -0400
Subject: Re: [PATCH] tracing - enable records during the module load
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1255183220-15640-1-git-send-email-jolsa@redhat.com>
References: <1255183220-15640-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 10 Oct 2009 11:26:41 -0400
Message-Id: <1255188401.1696.1201.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 16:00 +0200, jolsa@redhat.com wrote:
> I was debuging some module using "function" and "function_graph" tracers
> and noticed, that if you load module after you enabled tracing, the module's
> hooks will convert only to NOP instructions.

Yeah, I knew when I wrote this that new modules loaded during tracing
would just be initialized as nops, and not become part of that trace.
They will become part of later traces if the function tracing is stopped
and started again.

Actually, I took that as a safety feature, since most bad things can
happen when modules load and unload. But, I think your patch is still
safe. I'll apply it, play with it a bit, then queue it up for 2.6.33.

Thanks,

-- Steve

> 
> The attached patch enables modules' hooks if there's function
> trace allready on, thus allowing to trace module functions.


