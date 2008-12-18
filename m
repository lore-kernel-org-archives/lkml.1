Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYLRVge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYLRVge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYLRVgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:36:22 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:48437 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYLRVgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:36:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=It5w281XJHaHlVGZZDJvyc6CjxKsxdZPAwo4nTvyKBNp7Qlo8BrzSe9yOrdpUCBZta
         sT3L6oHGvdctsGzJdzap7BCKkbf7CZIcj459gvIDQ6U1KoY0M86uNrY3GRO9LtVLFwDu
         69i/P8sE5iSPdDKrP0BTKyAbyjJwFw+4+pvkM=
Message-ID: <c62985530812181336m6ab39c8ah410dff763bd02d24@mail.gmail.com>
Date: Thu, 18 Dec 2008 22:36:19 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer interrupt infinite loop
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081218211637.GF24271@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu>
	 <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain>
	 <20081218112216.GE14332@elte.hu>
	 <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com>
	 <20081218211637.GF24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/18 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> Hmm. No, I just tested by setting 1000 HZ and disabled NOHZ, the system
>> doesn't lockup unless I turn on the function graph tracer.
>
> but that's what we are interested in: the system locks up with HZ=1000 and
> with the tracer on - right?

Yes.

> Which means that it's not some hrtimer problem, but simply the traced
> timer tick takes more than 1 millisecond to execute under this
> virtualization.
>
>        Ingo
>

Oh ok I see. Sorry I'm a bit slow today...
So the solution would be to adapt dynamically the timeout between
hrtimer irq. But I don't know that much hrtimer
to implement such a feature...
