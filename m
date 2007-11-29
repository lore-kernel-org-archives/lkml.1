Return-Path: <linux-kernel-owner+w=401wt.eu-S1762744AbXK2Bpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762744AbXK2Bpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761523AbXK2Bpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:45:33 -0500
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:44059 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758260AbXK2Bpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:45:32 -0500
X-YMail-OSG: T7cSdrwVM1l8amhFngfCurNSd0Lg3sZbtX9wUcYFV6uEr30DZtMAbTdcSP6oF6LJ2ydk10L_0A--
X-RocketYMMF: rancidfat
Date: Wed, 28 Nov 2007 17:45:31 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Out of tree module using LSM
To: Jan Engelhardt <jengelh@computergmbh.de>, tvrtko.ursulin@sophos.com
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711290147181.22052@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <662625.5421.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Nov 28 2007 18:22, tvrtko.ursulin@sophos.com wrote:
> >
> >Talpa is modular itself being composed of a set of kernel modules of which 
> >not all are loaded simultaneously. Where possible LSM can be used and _no_ 
> >messing with syscall table will take place. Unfortunately where another 
> >LSM user is present that won't work
> 
> SELinux supports chaining, so if talpa is loaded as a secondary to selinux,
> where is the problem? For those LSMs which do not support chaining (*cough*
> apparmor *cough* be one, mtadm another), fix them.

Um, cough cough (I ready do have a nasty cold) SELinux supports
a very limited bit of chaining. I don't think you're going to be
chaining security_secid_to_secctx() or security_secctx_to_secid()
with the current SELinux code, but you could prove me wrong there.

Chaining is a red herring. If you want talpa it seems that you
have a use case that isn't going to require the presence of
another LSM. You may have other issues, but at this point I say
throw caution to the wind, clean it up based on the suggestions
you've seen here, and put the patch up as an RFC on the LSM list.

What's the worst that could happen?


Casey Schaufler
casey@schaufler-ca.com
