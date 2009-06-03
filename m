Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZFCQ37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZFCQ37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZFCQ3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:29:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbZFCQ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:29:52 -0400
Date: Wed, 3 Jun 2009 09:28:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Paris <eparis@parisplace.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <7e0fb38c0906030922u3af8c2abi8a2cfdcd66151a5a@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906030925480.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com>  <20090530230022.GO6535@oblivion.subreption.com>  <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain>  <20090531022158.GA9033@oblivion.subreption.com>  <alpine.DEB.1.10.0906021130410.23962@gentwo.org>
  <20090602203405.GC6701@oblivion.subreption.com>  <alpine.DEB.1.10.0906031047390.15621@gentwo.org>  <alpine.LFD.2.01.0906030800490.4880@localhost.localdomain>  <alpine.DEB.1.10.0906031121030.15621@gentwo.org>  <alpine.LFD.2.01.0906030827580.4880@localhost.localdomain>
 <7e0fb38c0906030922u3af8c2abi8a2cfdcd66151a5a@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Eric Paris wrote:
> 
> As I recall the only need for CONFIG_SECURITY is for the ability to
> override the check.

No, if you have SECURITY disabled entirely, the check goes away.

If you have SECURITY on, but then use the simple capability model, the 
check is there.

If you have SECURITY on, and then use SElinux, you can make it be dynamic.

> I think I could probably pretty cleanly change it to use
> CAP_SYS_RAWIO/SELinux permissions if CONFIG_SECURITY and just allow it
> for uid=0 in the non-security case?

We probably should, since the "capability" security version should 
generally essentially emulate the regular non-SECURITY case for root. 

			Linus
