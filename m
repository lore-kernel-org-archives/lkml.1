Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0BOVLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:11:23 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:33930 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab0BOVLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:11:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RIriE604O5TuoK+jVuZDOf6wdCSwshwO12tgyDr0OJSpkXJhzaJTeHdmRJP59sro6x
         RYLNsnLaP/yBjsFkNyXUh4pzKy59IHy+PSgd59vkvJtsJt6vLUlGN0P/9JTKEphIuxb+
         MBjqn4lgH6uOGTmDPOrpnOLyeNOGNreSXi/As=
MIME-Version: 1.0
In-Reply-To: <20100215202800.5192E1AD@magilla.sf.frob.com>
References: <1266214553-29476-1-git-send-email-vapier@gentoo.org> 
	<20100215202800.5192E1AD@magilla.sf.frob.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 15 Feb 2010 16:11:01 -0500
Message-ID: <8bd0f97a1002151311r3ba2f676ua00167edae152aa5@mail.gmail.com>
Subject: Re: [PATCH] tracehook: add some self tests
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 15:28, Roland McGrath wrote:
> This is something of a misnomer, since asm/syscall.h is the only thing you
> are testing.

it's meant as a starting point, not the end point.  so overtime people
can easily extend it.

> I'd make the more general point that this sort of "synthetic" test does not
> seem very useful.  At best, it can test the asm/syscall.h code for being
> internally consistent--but that doesn't test whether it's really correct.

i wrote it because i needed it when trying to make sure the various
i/n values worked correctly.  writing a bit of static code based on
just "n" is trivial, but avoiding a nest of code with i/n is a lot
harder.  and as i noted earlier, there is on code in the kernel that
ever calls with i being non-zero.

> IMHO this is not worth having unless it's an "empirical" test.  What I mean
> by that is one that really uses the asm/syscall.h calls as specified, and
> in the context specified.  So, you'd have to fork a user process and use
> ptrace on it to get it stopped at a syscall entry.  Then you can fetch the
> arguments, modify them, and look at the arguments it actually passes in to
> the syscall.

that would indeed be useful as a next point
-mike
