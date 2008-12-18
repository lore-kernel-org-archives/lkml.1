Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752261AbYLRPyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbYLRPyo (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 10:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYLRPyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 10:54:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57016 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYLRPyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 10:54:33 -0500
Date: Thu, 18 Dec 2008 15:53:29 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
        David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: PROC macro to annotate functions in assembly files
Message-ID: <20081218155329.GA30546@flint.arm.linux.org.uk>
Mail-Followup-To: Alexander van Heukelum <heukelum@fastmail.fm>,
	Alexander van Heukelum <heukelum@mailshack.com>,
	David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1636.1229511233@redhat.com> <20081217111213.GA8342@mailshack.com> <20081218114427.GD10593@flint.arm.linux.org.uk> <1229603702.27623.1290725827@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229603702.27623.1290725827@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 01:35:02PM +0100, Alexander van Heukelum wrote:
> Note that enforcing the pairing will be enabled by ARCH code. Is the
> construct you show here (two symbols covering identical code) the only
> problem you forsee? I don't want to introduce too many macro's to
> handle special cases, but this one should be solved.

Well, there are some cases where we don't have ENTRY but do have ENDPROC:

__pabt_usr:
        usr_entry
...
ENTRY(ret_from_exception)
...
ENDPROC(__pabt_usr)
ENDPROC(ret_from_exception)

        .macro  vector_stub, name, mode, correction=0
        .align  5

vector_\name:
...
ENDPROC(vector_\name)
        .endm

Not sure if we have any other oddities.
-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
