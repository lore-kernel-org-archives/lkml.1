Return-Path: <linux-kernel-owner+w=401wt.eu-S935561AbYCFSK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935561AbYCFSK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935293AbYCFSKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:10:35 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:3098 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935226AbYCFSKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:10:34 -0500
Date: Thu, 6 Mar 2008 19:10:30 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Joe Buck <Joe.Buck@synopsys.COM>
Cc: Paolo Bonzini <bonzini@gnu.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction   flag
Message-ID: <20080306181029.GA42904@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Joe Buck <Joe.Buck@synopsys.COM>, Paolo Bonzini <bonzini@gnu.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
	Richard Guenther <richard.guenther@gmail.com>,
	Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
	linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
References: <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> <47CF3F09.4080606@zytor.com> <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> <47CFF9A3.30309@gnu.org> <20080306141221.GC5236@dspnet.fr.eu.org> <20080306175841.GI17267@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306175841.GI17267@synopsys.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 09:58:41AM -0800, Joe Buck wrote:
> If the kernel allows state to leak from one process to another,
> for example from a process running as root to a process running as an
> ordinary user, it's a bug, with possible security implications.

I don't think that it is relevant in your case.  If you have the
signal handler in something that does not share the VM with the
interrupted thread, you will have a context switch which is supposed
to store the direction flag and restore the one from the handling
thread.  If you share the VM there is no context switch but you have
access to the exact same memory with the exact same rights, making the
leak irrelevant.

  OG.
