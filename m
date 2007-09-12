Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbXILWdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbXILWdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 18:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbXILWdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 18:33:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbXILWdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 18:33:41 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: O_NOLINK for open()
To: Brent Casavant <bcasavan@sgi.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 13 Sep 2007 00:33:26 +0200
References: <92Haf-7z7-5@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IValy-0000fU-Sd@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19GU7CwaxNAvkpt3FxeGC6jWknj/c0j2QRnxkk
 L34X9Q4HAIQxTu8hQFWRH7XnbzBNfWDK2iXBFYy0ZdlqVL3y8z
 uB4eHK/dxM/o4gXfs0/Gg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brent Casavant <bcasavan@sgi.com> wrote:

[...]
> I could mmap a temporary tmpfs file (tmpfs so that if there is a
> machine crash no sensitive data persists) which is created with
> permissions of 0, immediately unlink it, and pass the file
> descriptor through an AF_UNIX socket.  This does open up a very
> small window of vulnerability if another process is able to chmod
> the file and open it before the unlink.

If the process can chmod the file, it can ptrace the daemon, too.
Or, using CAP_DAC_OVERRIDE, it can patch the daemon.

Both will void any security.

> However, it occurs to me that this problem goes away if there were
> a method create a file in an unlinked state to begin with.  However
> there does not appear to be any such mechanism in Linux's open()
> interface.

Having no window for creating stale temp files is nice to have. We only
need a clever fool to implement it.-) But since it's hard to get killed
just in the right moment for having a stale temp file, there is very low
interest for this feature.
-- 
You know you're in trouble when packet floods are competing to flood you.
        -- grc.com

Friﬂ, Spammer: dnLqD2P@t.7eggert.dyndns.org npkrx@imrx.fp6.7eggert.dyndns.org
