Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYKMAKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYKMAKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 19:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYKMAKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 19:10:43 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:46010 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYKMAKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 19:10:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AKjd1DZ0e7hJvASErDg50i5D8OMlsfb/qxM3MOZDlaVFPbDI86skbL0/ct50gdWe9G
         Gwrmrp74NnukfNXr+wYLg2xSL/aAtCZO5MTltXJFh5JmbXOxm5nvMAiDrRHZiXvRN/gD
         2IT0ljW5Pu6fjIjhJUIRcLaQ84QKhOHe+y6Dg=
Message-ID: <c62985530811121610q2f745ed4lac0ea4fc709899d2@mail.gmail.com>
Date: Thu, 13 Nov 2008 01:10:41 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC v3][PATCH 0/2] Make ftrace able to trace function return
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <y0mr65gzncc.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49191C31.1050402@gmail.com>
	 <y0mr65gzncc.fsf@ton.toronto.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/12 Frank Ch. Eigler <fche@redhat.com>:
>
> Frederic Weisbecker <fweisbec@gmail.com> writes:
>
>> This patchset adds the ability for ftrace to trace the function even
>> on call time and on return time. So we can now measure the time of
>> execution of the most part of the functions inside the kernel with
>> ftrace. [...]
>
> By the way, one extra complication you may need to deal with, beyond
> normal retprobes, is that by the time dyn-ftrace gets hold of the
> function entry, some part of the function prologue will have been
> executed.  Because the mcount call/sequence is not the first
> instruction in the function body, is there a risk that the call frame
> cannot be reliably modified because of interference from those first
> few other instructions?  Maybe on some architectures/optimization
> levels?
>
> - FChE
>

I don't think that's a problem since CONFIG_FRAME_POINTER is activated
for function tracing.
Whatever instruction is called before the call to mcount, the return
address will remain just
before the frame pointer. It doesn't really differ from usual function
tracing which logs the address
of the parent by using this way.
And the case of dynamic_ftrace doesn't change anything since the call
to mcount is redirected to
ftrace_caller which can handle the return addresses properly.
