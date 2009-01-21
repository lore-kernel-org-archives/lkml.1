Return-Path: <linux-kernel-owner+w=401wt.eu-S1763754AbZAUIeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763754AbZAUIeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZAUIeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:34:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42090 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515AbZAUIeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:34:07 -0500
Date: Wed, 21 Jan 2009 09:31:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, ebiederm@xmission.com,
       roland@redhat.com, bastian@waldi.eu.org, daniel@hozac.com,
       xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][v7] Container-init signal semantics
Message-ID: <20090121083136.GA30368@redhat.com>
References: <20090117202638.GA11825@us.ibm.com> <3e8340490901202039r1ac7e0te5372690dfe81089@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8340490901202039r1ac7e0te5372690dfe81089@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Bryan Donlan wrote:
>
> On Sat, Jan 17, 2009 at 3:26 PM, Sukadev Bhattiprolu
> <sukadev@linux.vnet.ibm.com> wrote:
> >
> >        - container-init may be immune to unhandled fatal signals (like
> >          SIGUSR1) even if they are from ancestor namespace (SIGKILL is
> >          the only reliable signal from ancestor namespace).
>
> SIGSTOP is normally uncatchable; I note that patch 4 states that
> SIGSTOP is allowed through to container-init, but given this summary
> is SIGSTOP still reliable when sent to a container-init from an
> ancestor namespace?

Yes we should handle SIGSTOP fine if it sent from the parent namespace.

Also. Currently it is possible to ptrace the global init, but even
ptracer can't stop it (but ptrace_stop() works). With these patches
ptracer can stop init.

I forgot to mention this behaviour change, imho this side-effect
is good.

Oleg.

