Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbZFGOeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbZFGOeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZFGOd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:33:57 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:47669 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZFGOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mRjAY7m+QtmvnH7mI3n4F4txyZxien5kZmuHqgsW22qLflPR9aM1trAsfEsxzAXOac
         HG/MduJ5DfosQfDu/oVFUoqRVu0Urj8fQ6V8RNT13Hs+xH07OjOUDxR78Ymgz7YKJMRP
         CE/D2jfoOPow+3RBBzrjnMYHwJjI6c9y8tsUo=
Date: Sun, 7 Jun 2009 18:33:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:irq/numa] x86, apic: Fix dummy apic read operation
	together with broken MP handling
Message-ID: <20090607143356.GE4547@lenovo>
References: <20090607124840.GD4547@lenovo> <tip-103428e57be323c3c5545db8ad12667099bc6005@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-103428e57be323c3c5545db8ad12667099bc6005@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[tip-bot for Cyrill Gorcunov - Sun, Jun 07, 2009 at 02:24:31PM +0000]
| Commit-ID:  103428e57be323c3c5545db8ad12667099bc6005
| Gitweb:     http://git.kernel.org/tip/103428e57be323c3c5545db8ad12667099bc6005
| Author:     Cyrill Gorcunov <gorcunov@openvz.org>
| AuthorDate: Sun, 7 Jun 2009 16:48:40 +0400
| Committer:  Ingo Molnar <mingo@elte.hu>
| CommitDate: Sun, 7 Jun 2009 16:08:05 +0200
| 
| x86, apic: Fix dummy apic read operation together with broken MP handling
|

Hi Ingo, this commit will fix your case but to be fair
I'm a bit scared of disable_apic variable now spreading
all over the files. I've checked Makefile's and Kconfig
for situation when SMP turned on and apic.c is not compiled
(from hw POV on x86 it should not be possible since SMP
 requires APIC chip but dunno -- just something from
 inside of me says there could be a hidden problem).

I was also thinking about some common bitfiels for
apic features -- like one bit to figure out if
it was disabled via boot line, one bit for x2apic
mode enabled and so on. We have the cpu_has_...
helpers maybe the same for apic could be implemented?

How do you think?
 
	-- Cyrill
