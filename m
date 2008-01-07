Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYAGUhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYAGUhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbYAGUhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:37:43 -0500
Received: from neon.samage.net ([85.17.153.66]:35040 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758590AbYAGUhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:37:42 -0500
Message-ID: <51953.81.207.0.53.1199738255.squirrel@secure.samage.net>
In-Reply-To: <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp>
References: <20071231200247.GA30373@sergelap.austin.ibm.com>
    <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
    <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
    <20080106062609.GC20753@1wt.eu>
    <200801061636.GFE34382.FLtOMSOFHVOFJQ@I-love.SAKURA.ne.
    <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp>
Date: Mon, 7 Jan 2008 21:37:35 +0100 (CET)
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: "Indan Zupancic" <indan@nul.nu>
To: "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 76f3589a93270604ea078d468a2051b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Some questions:

On Sun, January 6, 2008 16:20, Tetsuo Handa wrote:
> I want to use this filesystem in case where a process with root privilege was
> hijacked but the behavior of the hijacked process is still restricted by MAC.

1) If the behaviour can be controlled, why can't the process be
   disallowed to change anything badly in /dev? Like disallowing anything
   from modifying existing nodes that weren't created by that process.
   That would have practically the same effect as your filesystem,
   won't it?

   Or phrased differently, if the MAC system used can't protect /dev, it
   won't be able to protect other directories either, and if it can't
   protect e.g. my homedir, doesn't it make the whole MAC system
   ineffective? And if the MAC system used is ineffective, your
   filesystem is useless and you've bigger problems to fix.

2) The MAC system may not be able to guarantee certain combinations
   of device names and properties, but isn't that policy that shouldn't
   be in the kernel anyway? But if it is, shouldn't all device nodes be
   checked? That is, shouldn't it be a global check instead of a filesystem
   specific one?

3) Code efficiency. Thousand lines of code just to close one very specific
   attack, which can be done in lots of different other ways that all need
   to be prevented by the MAC system. (mounting over it, intercepting open
   calls, duping the fd, etc.) Is it worth it?

I really don't care how you try to protect your system, but I don't think
this is an effective way to do it.

Good luck,

Indan


