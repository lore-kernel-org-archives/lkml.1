Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYFONhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYFONhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 09:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbYFONhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 09:37:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:45414 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbYFONhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 09:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SfUfAJexfS9x63sMZu0DUOJorBW172mPOiw720wYjJ5nQvNgzGbKYpuEnP93zIAR4u
         fTSuDeHPmkQefIxC3YF7+PCpEaE/7P73sgfHnvpJNbB1D3yGkOZOHp9Vgno9a6Jrb5tI
         PbVYa0YJgLxsCa5+SvRm45QOeOrnrnk5TovQU=
Subject: Re: how to find when a symbol introduced into the kernel
From: Calvin Walton <calvin.walton@gmail.com>
To: Zhaohui Wang <zwange@gmu.edu>
Cc: linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <000b01c8ce6b$a7bfda50$f73f8ef0$@edu>
References: <000b01c8ce6b$a7bfda50$f73f8ef0$@edu>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 09:37:24 -0400
Message-Id: <1213537044.25647.4.camel@zem>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-14 at 18:11 -0400, Zhaohui Wang wrote:
> 
> Hi all
> 
> To write multiple kernel version compatible programs, I need to know when a specific symbol (a struct or a function)were introduced in to the kernel tree
> 
> Binary search against multiple kernel sources is a way,but is still slow.Is there any fast way to use modern git technology to make my life easier?
> 
> Many thanks.

You're probably looking for the command
  git log -S functionname
a.k.a. the git pickaxe.

That will show you all of the commits that added or removed a line
containing the name you're interested in, and you can then check just
those changes to see what compatibility may have changed.

To find out what kernel release one of those commits went into, you can
use
  git describe <sha1-hash>
and it will report the last tagged kernel version before that commit was
added.

Hope that helps!

-- 
Calvin Walton <calvin.walton@gmail.com>

