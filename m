Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbYAJSAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbYAJSAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYAJR7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:59:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55519 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbYAJR7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:59:48 -0500
Date: Thu, 10 Jan 2008 19:02:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: John Reiser <jreiser@BitWagon.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: STT_FUNC for assembler checksum and semaphore ops" in git-x86
Message-ID: <20080110180225.GA747@one.firstfloor.org>
References: <20080109215725.GA18185@basil.nowhere.org> <20080110074201.GA12585@uranus.ravnborg.org> <478649D8.9080209@BitWagon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478649D8.9080209@BitWagon.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It does look ugly.  But .size and .type are oriented towards static
> description, while the dwarf2 CurrentFrameInfo (CFI) annotations
> are oriented towards dynamic traceback and unwinding.  Forcing the

ENTRY/ENDPROC have nothing to do with dwarf2. That is CFI_STARTPROC/ENDPROC.

But actually checking the default implementation in linkage.h already
implements size:

#ifndef END
#define END(name) \
  .size name, .-name
#endif

#ifndef ENDPROC
#define ENDPROC(name) \
  .type name, @function; \
  END(name)
#endif

Are you sure it doesn't work?  Your patch should be not needed. If it's
still wrong then just ENDPROCs() need to be added.

-Andi

