Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbYJaPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbYJaPcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYJaPco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:32:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:50101 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYJaPcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vKmRC4d/TRSMtTXMKGwz1isWyEGQ4bSU34qr6ZpfFm4+Xj2TYUsf6/JJNSZr3aFD5W
         +61xoxfRtlu6XZGltzC97nQPaUyNs7o6o9ILA6w/OUoaNvxX2lGVan4/vZllTaHLIDdq
         76o5zp0URbLPnIG4jZC/yibULE+YC/Wik786E=
Message-ID: <863e9df20810310832uadf4daay7b5a98b677d86561@mail.gmail.com>
Date: Fri, 31 Oct 2008 11:32:42 -0400
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: distinguish kretprobe'd functions in trace logs
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>, ananth@in.ibm.com,
       jkenisto@us.ibm.com, mhiramat@redhat.com
In-Reply-To: <alpine.DEB.1.10.0810311036130.20157@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483C53EE.2060602@gmail.com>
	 <alpine.DEB.1.10.0810302227360.21031@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0810311036130.20157@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 10:36 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> Hi Abhishek,
>>
>> Now that this code is in mainline, it has become apparent that
>> kretprobe_trampoline is not defined on all archs as a global like it is in
>> x86. This needs to be fixed (it breaks ia64 build).
>>
>
> Also note that kretprobe_trampoline will not be the return address.
>
> Hmm, I think I can solve this by not even doing the test here, but simply
> on the name itself.

Ok. I wonder if it would be a good idea to export kretprobe_trampoline
(or kretprobe_trampoline->ip) via asm/kprobes.h for all archs, for the
kind of checks done here for ftrace (to have them elsewhere too like
in OOPs generation etc).

Adding Kprobe folks in CC

-- Abhishek
