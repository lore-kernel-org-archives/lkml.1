Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYKFN2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYKFN2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYKFN2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:28:36 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:35576 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbYKFN2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:28:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=igDbKqd9Do4qPl8r4oEfNhnydo4Kvku19fyxrAH26lJHhWnpY4s9edmVvy+FhAl1tU
         6OQ1eS7i/nI7tFAnDthP+KcpDKjZbSVKe1zWtFPKqLVnQrbObLHN57j1ioCVuOEXKVEZ
         PbgzMcPXrnFXFf5nupG9/MWvoISMwuAbjWpBc=
Message-ID: <c62985530811060528r5bff8c1ct9487936b978d6ecb@mail.gmail.com>
Date: Thu, 6 Nov 2008 14:28:34 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: add an fsync tracer
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <1225976138.7803.4485.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105094902.27ec4b39@infradead.org>
	 <1225976138.7803.4485.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/6 Peter Zijlstra <peterz@infradead.org>:
> Please work on getting something like a syscall tracer, or lttng like
> event tracer.
>
> Both of those should be able to find such badness, but are also able to
> diagnose many more issues.


BTW. Why not adding a kind of tracer_ctrl callback on the
struct_tracer? This way we could add some custom
options on the iter_ctrl file that could be transmitted to the current_tracer.

For example considering a syscall tracer.
By default if we don't write anything on iter_ctrl, it traces all
syscalls. But if we do:
echo fsync > iter_ctrl
Only the fsync call will be traced (unused tracepoint would be disabled).

A tracer just have to implement this new callback and transmit the
options it support.
