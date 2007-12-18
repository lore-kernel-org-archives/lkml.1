Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbXLRAkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbXLRAkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXLRAjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:39:55 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35502 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXLRAjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:39:54 -0500
Date: Mon, 17 Dec 2007 18:39:55 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Message-ID: <20071218003955.GA27048@sergelap.austin.ibm.com>
References: <20071216080441.435456586@I-love.SAKURA.ne.jp> <20071216080628.061470932@I-love.SAKURA.ne.jp> <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp> <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp> <20071217194802.GA14156@sergelap.austin.ibm.com> <200712180003.lBI03N7F092396@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712180003.lBI03N7F092396@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> Hello.
> 
> Serge E. Hallyn wrote:
> > CAP_MKNOD will be removed from its capability
> I think it is not enough because the root can rename/unlink device files
> (mv /dev/sda1 /dev/tmp; mv /dev/sda2 /dev/sda1; mv /dev/tmp /dev/sda2).

Sure but that doesn't bother us :)

The admin in the container has his own /dev directory and can do what he
likes with the devices he's allowed to have.  He just shouldn't have
access to others.  If he wants to rename /dev/sda1 to /dev/sda5 that's
his choice.

> > To use your approach, i guess we would have to use selinux (or tomoyo)
> > to enforce that devices may only be created under /dev?
> Everyone can use this filesystem alone.

Sure but it is worthless alone.

No?

What will keep the container admin from doing 'mknod /root/hda1 b 3 1'?

> But use with MAC (or whatever access control mechanisms that prevent
> attackers from unmounting/overlaying this filesystem) is recomennded.

-serge
