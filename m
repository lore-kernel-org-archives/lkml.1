Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYCBShf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYCBShf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYCBShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:37:24 -0500
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:37529 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751914AbYCBShX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:37:23 -0500
X-YMail-OSG: 8AWTgmsVM1loNH6bREFIWk8d122G_s575thTioZCAGIu8TU2ypGXAIBiXDYtncx5hF3ISq9Dug--
X-RocketYMMF: rancidfat
Date: Sun, 2 Mar 2008 10:37:22 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH -v3 -mm] LSM: Add security= boot parameter
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Anrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080302105946.GA6406@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <548866.30741.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi!,
> 
> [
> Fixed two bugs:
>        - concurrency: incrementing and testing atomic_t in different places.
>        - overflow: not ending string with NULL after using strncpy().
>        - I'll never write a patch when I'm asleep, sorry :(
> 
> Added more verbose messages to SMACK and SELinux if they were not 
> chosen on boot.
> 
> Casey: Failing to take permission to register an LSM does not mean that 
>        the other has registered its security_ops yet. It just means that
>        the other asked for allowance to call register_security(). It's 
>        not yet guraranteed that this registration succeeded.
> 
>        This means that adding "SELinux: failed to load, LSM %s is loaded"
>        may lead to %s = "dummy" in case of a highly concurrent SMP system.
> ]

Personally, I'd be OK with seeing "dummy" on my Altix on occasion. :-)
Perhaps "SELinux: Not registered, %s is reported" would address the
concern. It would be really good to see the value in the 99 44/100%
of the cases where it is available, even if it means admitting that
there are limited circumstances where you might know that someone
got there ahead of you, but not who it was. I don't think it's
worth going to heroic efforts to make sure it's available.


Casey Schaufler
casey@schaufler-ca.com
