Return-Path: <linux-kernel-owner+w=401wt.eu-S936983AbZAPSmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936983AbZAPSmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761510AbZAPSmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:42:46 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:53113 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761302AbZAPSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vx2+1XcQm33/FQsmWBQ7twc9runqKd0DxFQlagoz/gdtv5tNKvC0QQsXdX+qYRj/WC
         eS8AxYi47RwGRX4WbH2DsH2VGQwkphktHMIoFz052oHMzrRZrnt4tHinVmpN0WnNlQnI
         jAKwLa7wT7nNdC2tb2A3zWTpPKad49l2EP8wc=
MIME-Version: 1.0
In-Reply-To: <20090107195832.733912000@polaris-admin.engr.sgi.com>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
	 <20090107195832.733912000@polaris-admin.engr.sgi.com>
Date: Fri, 16 Jan 2009 10:42:43 -0800
Message-ID: <12c511ca0901161042x5aab46edy70d0d89c84792cd9@mail.gmail.com>
Subject: Re: [PATCH 3/5] cpumask: convert misc driver functions
From: Tony Luck <tony.luck@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dean Nelson <dcn@sgi.com>, Robert Richter <robert.richter@amd.com>,
       oprofile-list@lists.sf.net, Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Ursula Braun <ursula.braun@de.ibm.com>,
       linux390@de.ibm.com, linux-s390@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+void __exit buffer_sync_cleanup(void)
+{
+	free_cpumask_var(marked_cpus);
+}

This breaks ia64 with CONFIG_OPROFILE=y

`buffer_sync_cleanup' referenced in section `.init.text' of
arch/ia64/oprofile/built-in.o: defined in discarded section
`.exit.text' of arch/ia64/oprofile/built-in.o
make: *** [.tmp_vmlinux1] Error 1

-Tony
