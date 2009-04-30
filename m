Return-Path: <linux-kernel-owner+w=401wt.eu-S1763595AbZD3PHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763595AbZD3PHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762446AbZD3PHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:07:18 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:55525 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761813AbZD3PHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:07:16 -0400
Date: Thu, 30 Apr 2009 17:09:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, jdb@comx.dk,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: boot/compressed/vmlinux.lds.S: fix build of bzImage with 64 bit compiler
Message-ID: <20090430150924.GA8656@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain> <tip-83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f@git.kernel.org> <49F9BB47.7080806@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F9BB47.7080806@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 07:52:55AM -0700, H. Peter Anvin wrote:
> tip-bot for Sam Ravnborg wrote:
> > Commit-ID:  83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f
> > Gitweb:     http://git.kernel.org/tip/83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f
> > Author:     Sam Ravnborg <sam@ravnborg.org>
> > AuthorDate: Thu, 30 Apr 2009 12:03:16 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu, 30 Apr 2009 12:36:50 +0200
> > 
> > x86: boot/compressed/vmlinux.lds.S: fix build of bzImage with 64 bit compiler
> > 
> > Jesper reported that he saw following build issue:
> > 
> >  > ld:arch/x86/boot/compressed/vmlinux.lds:9: syntax error
> >  > make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
> >  > make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
> >  > make: *** [bzImage] Error 2
> > 
> > CPP defines the symbol "i386" to "1".
> > Undefine this to fix it.
> > 
> 
> I'm wondering if we should build the *.lds.S with -ansi or some other
> gcc option which disables ALL non-underscore macros.

I did not know that -ansi had this effect.
We are only seldomly hitting this issue and I wonder
if it could break something in out included headers.
Most likely not.

	Sam
