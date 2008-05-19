Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbYESPKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbYESPKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbYESPHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:07:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30176 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbYESPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hi4UzzJO6uT3NlPWXdhHl+Kc7JU2YE/H7HemG1z/AFBpC8VRA4aiYII54kQrFFb4UdBWMY8+nuVgpfxc6iVNUdi8x9EHaHcnWfY+c3ZvR7qeU73MACDlGzuiMuqs6Z281HPP4gUQl+hy5pnvdnuOp0m0kjmgp2xl42MVpMn12LY=
Message-ID: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
Date: Mon, 19 May 2008 23:07:34 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       "Shaohua Li" <shaohua.li@intel.com>, "Greg KH" <greg@kroah.com>
Subject: recent 2.6.26 kernel hangs at suspend
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can simulate this and it's definitely a bug, but I could only bisect
up to a point and the kernel would not boot after tat.

The bug is that my X60s notebook would not suspend-to-ram on the 2nd try.

Boot up -> suspend to ram -> ok -> resume -> suspend to ram -> hang!

The hang would only happen while in X.

If I don't enter X, it'll not hang on suspend to ram.

I tried git bisect but can only get to this commit
4a27214d7be31e122db4102166f49ec15958e8e9.

The next commit b82287587ef9917afbea5fcbf7aa63424b6f3719 would not boot.

How can I get pass the "bad" commit. I've tried "skip" or "next", but
still won't boot.

And it doesn't seem like it's X as 2.6.25 kernel can suspend and
resume many times in X without problem.

Here's how I bisected ...

git-bisect start
# bad: [b8291ad07a7f3b5b990900f0001198ac23ba893e] Linux 2.6.26-rc3
git-bisect bad b8291ad07a7f3b5b990900f0001198ac23ba893e
# good: [4b119e21d0c66c22e8ca03df05d9de623d0eb50f] Linux 2.6.25
git-bisect good 4b119e21d0c66c22e8ca03df05d9de623d0eb50f
# good: [c328d54cd4ad120d76284e46dcca6c6cf996154a] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb
git-bisect good c328d54cd4ad120d76284e46dcca6c6cf996154a
# bad: [25a025863e024f6b86b48137b10b4960c50351b0] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git-bisect bad 25a025863e024f6b86b48137b10b4960c50351b0
# bad: [62d9f0dbc92d7e398fde53fc6021338393522e68] KVM: add ioctls to
save/store mpstate
git-bisect bad 62d9f0dbc92d7e398fde53fc6021338393522e68
# good: [ce1d5b23a8d1e19866ab82bdec0dc41fde5273d8] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git-bisect good ce1d5b23a8d1e19866ab82bdec0dc41fde5273d8
# good: [a2826190aa157a1d29bef70ca81f8b51a9b36d29] IDE: Coding Style
fixes to drivers/ide/pci/it8213.c
git-bisect good a2826190aa157a1d29bef70ca81f8b51a9b36d29
# bad: [9b79ed952bd7344d40152f8a560ad8a0d93f3886] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-generic-bitops-v3
git-bisect bad 9b79ed952bd7344d40152f8a560ad8a0d93f3886
# bad: [4a27214d7be31e122db4102166f49ec15958e8e9] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-fixes
git-bisect bad 4a27214d7be31e122db4102166f49ec15958e8e9
# bad: [b82287587ef9917afbea5fcbf7aa63424b6f3719] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-misc
git-bisect bad b82287587ef9917afbea5fcbf7aa63424b6f3719


Thanks,
Jeff.
