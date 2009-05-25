Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZEYAhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZEYAhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZEYAhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:37:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56122 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZEYAhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:37:24 -0400
Message-Id: <200905250037.n4P0bFwe057503@www262.sakura.ne.jp>
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 25 May 2009 09:37:15 +0900
References: <20090503215615.GA1368@ucw.cz> <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp> <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp> <200905142108.JIF10080.OOFHJVFtOSQMFL@I-love.SAKURA.ne.jp> <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org> <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp>
In-Reply-To: <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 24052009 #2024277, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------- Forwarded Message

Serge E. Hallyn wrote:
> Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> > James Morris wrote:
> > > On Thu, 14 May 2009, Tetsuo Handa wrote:
> > > 
> > > > ---
> > > >  security/tomoyo/common.c   |  456 +++++++++++++++++++-----------------
> > > >  security/tomoyo/common.h   |  134 ++++++++--
> > > >  security/tomoyo/domain.c   |  437 +++++++++++++---------------------
> > > >  security/tomoyo/file.c     |  369 +++++++++++++++--------------
> > > >  security/tomoyo/realpath.c |  567 ++++++++++++++++++++++++++++++++++-----------
> > > >  security/tomoyo/realpath.h |   25 +
> > > >  security/tomoyo/tomoyo.c   |   40 +--
> > > >  security/tomoyo/tomoyo.h   |   13 -
> > > >  8 files changed, 1190 insertions(+), 851 deletions(-)
> > > 
> > > This seems like an awfully large and invasive patch just to add GC support 
> > > which you didn't originally didn't think was necessary.
> > > 
> > > I think it needs review from people outside of your project.
> > 
> > I see. Would somebody please review?
> 
> Please resend to me privately.  (I've deleted it)
> 
> -serge
> 
Sure.

The key points are:

  (1) Should TOMOYO avoid sleeping operations inside a semaphore?

      Until #14, TOMOYO was using singly linked list and thus reader process
      did not require any locks. But in #15, TOMOYO is using standard doubly
      linked list and thus reader process requires a semaphore. This might
      dull the system's response. In this patch, I moved sleeping operations
      (i.e. kmalloc(GFP_KERNEL)/kfree()) to outside the semaphore protected
      code.

  (2) Should TOMOYO have GC support?

      Several reviewers had been asking me that TOMOYO should release memory
      used by deleted policy. At first, I didn't feel it is necessary. But in
      #15, TOMOYO uses standard doubly linked list and getting close to be able
      to know whether there is a reader process or not. Also, I changed to use
      kmalloc(GFP_KERNEL)/kfree() to realize the key point (1) in this patch.
      TOMOYO is almost ready to have GC support.

This patch is very large, so I'll create splitted patches if you need.
Thank you for your time.

------- End of Forwarded Message
