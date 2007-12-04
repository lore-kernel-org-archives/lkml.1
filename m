Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbXLDWO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbXLDWO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbXLDWOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:14:22 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:10795 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXLDWOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:14:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VvVZvAMmGAIWEMidI7Ixxiq67hvo04t00gEanlBi+Z5stWpJ3B5EE6TPp9IJ0Akx0pRnkEibMFfe4yuZjzAvnUMJ54XK55zI7XQz0KqjL9FVZo9bbmV3DIycMNhzcZocMDYQVhSZWfwLE5CcF8dIuuCEiZlg85Q1/vy2Me7S85E=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
Date: Tue, 4 Dec 2007 14:14:13 -0800
User-Agent: KMail/1.9.1
Cc: "Avi Kivity" <avi@qumranet.com>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com
References: <11967843881946-git-send-email-gcosta@redhat.com> <4755A809.4050305@qumranet.com> <5d6222a80712041141p5fbc0c0ei68696f054cc8a303@mail.gmail.com>
In-Reply-To: <5d6222a80712041141p5fbc0c0ei68696f054cc8a303@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041414.14159.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2007 11:41, Glauber de Oliveira Costa wrote:
> On Dec 4, 2007 5:18 PM, Avi Kivity <avi@qumranet.com> wrote:
> > There is no cr8 register on i386.  This had better be protected by an
> > #ifdef.
>
> Sure. I mentioned it in the changelog. I, however, am not sure If I
> agree it should be enclosed
> in ifdefs. Me and Jeremy discussed it a while ago, and we seem to
> agree that for those functions
> that are exclusive of one architecture, there were no need for ifdefs.
> Any usage by the other arch
> is a bug.
>
> But I admit that I'm not particularly biased here, and I can change
> it, if there's agreement that
> an ifdef here is the way to go.
>
> > (you're likely not getting an error since it's a static inline, so the
> > asm is never emitted)
>
> Which also means it does not affect the binary in anyway. No bigger
> code, no nothing.

If future changes will mistakenly make 32-bit x86 call native_read_cr8(),
you will get no warning. (Hmmm. Maybe as will complain, I'm not sure).
If it explicitly ifdefed out for 32 bits, it's easier to detect misuse.
--
vda
