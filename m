Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYKMIrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYKMIrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYKMIqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:46:55 -0500
Received: from aun.it.uu.se ([130.238.12.36]:49521 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYKMIqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:46:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18715.59672.641830.690773@harpo.it.uu.se>
Date: Thu, 13 Nov 2008 09:45:12 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: ia32_signal: remove unnecessary padding
In-Reply-To: <491B1C7C.5000906@zytor.com>
References: <491A48E9.8020909@ct.jp.nec.com>
	<491A496B.5010505@ct.jp.nec.com>
	<20081112112937.GA6372@elte.hu>
	<18714.52512.213371.33245@harpo.it.uu.se>
	<491B0E6F.2010301@zytor.com>
	<491B1A40.5020900@ct.jp.nec.com>
	<491B1C7C.5000906@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > Hiroshi Shimamoto wrote:
 > > H. Peter Anvin wrote:
 > >> Mikael Pettersson wrote:
 > >>> It does cause each signal delivery to leak 2 uninitialised
 > >>> kernel bytes to the end of retcode[], which seems unnecessary.
 > >> Not just unnecessary, it is a huge no-no for security.
 > > 
 > > Am I missing important thing?
 > > The frame->retcode is 8 bytes and packed structure with padding
 > > is 10 bytes each, and the code is copied to user stack 8 bytes only.
 > > 
 > > err |= __copy_to_user(frame->retcode, &code, 8);
 > > 
 > > I don't think the behavior is changed.
 > > 
 > 
 > Ah, nevermind, then.  Then it fine, obviously.

Agreed. I wonder how on earth those templates ended
up as 10 bytes large when retcode[] always has been
8 bytes.
